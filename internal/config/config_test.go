package config

import (
	"os"
	"path/filepath"
	"testing"
)

func TestLoadDefault(t *testing.T) {
	dir := t.TempDir()
	cfg, err := Load(dir)
	if err != nil {
		t.Fatalf("Load returned error: %v", err)
	}
	if cfg.Version != "3.0" {
		t.Errorf("expected version 3.0, got %s", cfg.Version)
	}
	if cfg.Personality != "balanced" {
		t.Errorf("expected personality balanced, got %s", cfg.Personality)
	}
	if cfg.Pack != "" {
		t.Errorf("expected empty pack, got %s", cfg.Pack)
	}
}

func TestSaveAndLoad(t *testing.T) {
	dir := t.TempDir()
	cfg := &BridgeConfig{
		Version:         "3.0",
		Pack:            "claude-code",
		Personality:     "strict",
		Specializations: []string{"frontend", "api"},
	}

	if err := cfg.Save(dir); err != nil {
		t.Fatalf("Save returned error: %v", err)
	}

	// Verify file exists
	path := filepath.Join(dir, ConfigFile)
	if _, err := os.Stat(path); err != nil {
		t.Fatalf("config file not created: %v", err)
	}

	// Load back
	loaded, err := Load(dir)
	if err != nil {
		t.Fatalf("Load returned error: %v", err)
	}
	if loaded.Pack != "claude-code" {
		t.Errorf("expected pack claude-code, got %s", loaded.Pack)
	}
	if loaded.Personality != "strict" {
		t.Errorf("expected personality strict, got %s", loaded.Personality)
	}
	if len(loaded.Specializations) != 2 {
		t.Errorf("expected 2 specializations, got %d", len(loaded.Specializations))
	}
}

func TestPacks(t *testing.T) {
	packs := Packs()
	if len(packs) != 5 {
		t.Errorf("expected 5 packs, got %d", len(packs))
	}
}

func TestPersonalities(t *testing.T) {
	p := Personalities()
	if len(p) != 3 {
		t.Errorf("expected 3 personalities, got %d", len(p))
	}
}

func TestSpecializationNames(t *testing.T) {
	s := SpecializationNames()
	if len(s) != 7 {
		t.Errorf("expected 7 specializations, got %d", len(s))
	}
}
