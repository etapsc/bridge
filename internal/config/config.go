package config

import (
	"encoding/json"
	"os"
	"path/filepath"
)

// BridgeConfig is the .bridge.json file stored at project root.
// Tracks active personality, specializations, pack type, and version.
type BridgeConfig struct {
	Version         string   `json:"version"`
	Pack            string   `json:"pack"`
	Personality     string   `json:"personality"`
	Specializations []string `json:"specializations"`
}

const ConfigFile = ".bridge.json"

// Load reads .bridge.json from the given directory.
// Returns a default config if the file doesn't exist.
func Load(dir string) (*BridgeConfig, error) {
	path := filepath.Join(dir, ConfigFile)
	data, err := os.ReadFile(path)
	if err != nil {
		if os.IsNotExist(err) {
			return &BridgeConfig{
				Version:     "3.0",
				Personality: "balanced",
			}, nil
		}
		return nil, err
	}

	var cfg BridgeConfig
	if err := json.Unmarshal(data, &cfg); err != nil {
		return nil, err
	}
	return &cfg, nil
}

// Save writes .bridge.json to the given directory.
func (c *BridgeConfig) Save(dir string) error {
	path := filepath.Join(dir, ConfigFile)
	data, err := json.MarshalIndent(c, "", "  ")
	if err != nil {
		return err
	}
	return os.WriteFile(path, append(data, '\n'), 0644)
}

// Packs returns the list of valid pack names.
func Packs() []string {
	return []string{"full", "standalone", "claude-code", "codex", "opencode"}
}

// Personalities returns the list of valid personality names.
func Personalities() []string {
	return []string{"strict", "balanced", "mentoring"}
}

// Specializations returns the list of valid specialization names.
func SpecializationNames() []string {
	return []string{"frontend", "backend", "api", "data", "infra", "mobile", "security"}
}
