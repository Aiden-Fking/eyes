package main

import (
	"database/sql"
	"encoding/json"
	"log"
	"net/http"
	"os"
	"time"

	_ "github.com/lib/pq"
)

type eventRequest struct {
	SessionID string                 `json:"sessionId"`
	EventType string                 `json:"eventType"`
	Payload   map[string]interface{} `json:"payload"`
	Ts        time.Time              `json:"ts"`
}

type server struct {
	db *sql.DB
}

func main() {
	dsn := getenv("TRAINING_DB_DSN", "postgres://eyes:eyes@localhost:5432/eyes?sslmode=disable")
	addr := getenv("TRAINING_ADDR", ":8081")

	db, err := sql.Open("postgres", dsn)
	if err != nil {
		log.Fatalf("db open: %v", err)
	}
	if err := db.Ping(); err != nil {
		log.Fatalf("db ping: %v", err)
	}

	s := &server{db: db}
	http.HandleFunc("/healthz", s.healthz)
	http.HandleFunc("/v1/training/events", s.createEvent)
	http.HandleFunc("/v1/training/sessions/summary", s.sessionSummary)

	log.Printf("training-service listening on %s", addr)
	log.Fatal(http.ListenAndServe(addr, nil))
}

func (s *server) healthz(w http.ResponseWriter, _ *http.Request) {
	w.WriteHeader(http.StatusOK)
	_, _ = w.Write([]byte("ok"))
}

func (s *server) createEvent(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "method not allowed", http.StatusMethodNotAllowed)
		return
	}
	var req eventRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, "invalid json", http.StatusBadRequest)
		return
	}
	if req.SessionID == "" || req.EventType == "" {
		http.Error(w, "sessionId and eventType are required", http.StatusBadRequest)
		return
	}
	if req.Ts.IsZero() {
		req.Ts = time.Now().UTC()
	}

	payload, err := json.Marshal(req.Payload)
	if err != nil {
		http.Error(w, "payload encode failed", http.StatusBadRequest)
		return
	}

	_, err = s.db.Exec(`
		INSERT INTO training_events(session_id, event_type, payload, event_time)
		VALUES($1, $2, $3::jsonb, $4)
	`, req.SessionID, req.EventType, string(payload), req.Ts)
	if err != nil {
		log.Printf("insert event failed: %v", err)
		http.Error(w, "failed to store event", http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusAccepted)
	_, _ = w.Write([]byte(`{"status":"accepted"}`))
}

func (s *server) sessionSummary(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodGet {
		http.Error(w, "method not allowed", http.StatusMethodNotAllowed)
		return
	}
	sessionID := r.URL.Query().Get("sessionId")
	if sessionID == "" {
		http.Error(w, "sessionId is required", http.StatusBadRequest)
		return
	}

	var total int
	var correct int
	err := s.db.QueryRow(`
		SELECT
			COUNT(*) AS total,
			COALESCE(SUM((payload->>'correct')::int), 0) AS correct
		FROM training_events
		WHERE session_id = $1
	`, sessionID).Scan(&total, &correct)
	if err != nil {
		http.Error(w, "summary query failed", http.StatusInternalServerError)
		return
	}

	resp := map[string]interface{}{
		"sessionId": sessionID,
		"total":     total,
		"correct":   correct,
	}
	w.Header().Set("Content-Type", "application/json")
	_ = json.NewEncoder(w).Encode(resp)
}

func getenv(key, fallback string) string {
	v := os.Getenv(key)
	if v == "" {
		return fallback
	}
	return v
}
