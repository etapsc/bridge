package pack

import (
	"os"
	"path/filepath"
	"testing"
)

func TestResolveFolder(t *testing.T) {
	dir := t.TempDir()
	packDir := filepath.Join(dir, "bridge-claude-code")
	os.MkdirAll(packDir, 0755)

	src := Resolve(dir, "claude-code", "etapsc/bridge", "latest")
	if src.Mode != SourceFolder {
		t.Errorf("expected folder mode, got %s", src.Mode)
	}
	if src.Path != packDir {
		t.Errorf("expected path %s, got %s", packDir, src.Path)
	}
}

func TestResolveTar(t *testing.T) {
	dir := t.TempDir()
	tarPath := filepath.Join(dir, "bridge-codex.tar.gz")
	os.WriteFile(tarPath, []byte("fake"), 0644)

	src := Resolve(dir, "codex", "etapsc/bridge", "latest")
	if src.Mode != SourceTar {
		t.Errorf("expected tar mode, got %s", src.Mode)
	}
}

func TestResolveRemoteLatest(t *testing.T) {
	dir := t.TempDir()
	src := Resolve(dir, "full", "etapsc/bridge", "latest")
	if src.Mode != SourceRemote {
		t.Errorf("expected remote mode, got %s", src.Mode)
	}
	expected := "https://github.com/etapsc/bridge/releases/latest/download/bridge-full.tar.gz"
	if src.URL != expected {
		t.Errorf("expected URL %s, got %s", expected, src.URL)
	}
}

func TestResolveRemoteVersioned(t *testing.T) {
	dir := t.TempDir()
	src := Resolve(dir, "full", "etapsc/bridge", "v3.0.0")
	expected := "https://github.com/etapsc/bridge/releases/download/v3.0.0/bridge-full.tar.gz"
	if src.URL != expected {
		t.Errorf("expected URL %s, got %s", expected, src.URL)
	}
}
