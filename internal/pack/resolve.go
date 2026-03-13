package pack

import (
	"fmt"
	"os"
	"path/filepath"
)

// SourceMode describes how pack content will be sourced.
type SourceMode string

const (
	SourceFolder SourceMode = "folder"
	SourceTar    SourceMode = "tar"
	SourceRemote SourceMode = "remote"
)

// Source describes a resolved pack source.
type Source struct {
	Mode SourceMode
	Path string // folder path or archive path
	URL  string // remote download URL (only for SourceRemote)
}

// Resolve determines the source for a pack by checking (in order):
// 1. Local folder: {baseDir}/bridge-{pack}/
// 2. Local tar: {baseDir}/bridge-{pack}.tar.gz
// 3. Remote: GitHub Releases URL
func Resolve(baseDir, pack, repo, version string) Source {
	folderPath := filepath.Join(baseDir, fmt.Sprintf("bridge-%s", pack))
	tarPath := filepath.Join(baseDir, fmt.Sprintf("bridge-%s.tar.gz", pack))

	if info, err := os.Stat(folderPath); err == nil && info.IsDir() {
		return Source{Mode: SourceFolder, Path: folderPath}
	}

	if _, err := os.Stat(tarPath); err == nil {
		return Source{Mode: SourceTar, Path: tarPath}
	}

	var url string
	if version == "latest" {
		url = fmt.Sprintf("https://github.com/%s/releases/latest/download/bridge-%s.tar.gz", repo, pack)
	} else {
		url = fmt.Sprintf("https://github.com/%s/releases/download/%s/bridge-%s.tar.gz", repo, version, pack)
	}
	return Source{Mode: SourceRemote, URL: url}
}
