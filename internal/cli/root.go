package cli

import (
	"github.com/spf13/cobra"
)

func Execute(version string) error {
	rootCmd := &cobra.Command{
		Use:     "bridge",
		Short:   "BRIDGE — structured development workflow for AI coding agents",
		Long:    "BRIDGE v3 — Brainstorm → Requirements → Implementation Design → Develop → Gate → Evaluate.\nInteractive TUI for project setup, customization, and pack management.",
		Version: version,
	}

	rootCmd.AddCommand(
		newCmd(),
		addCmd(),
		orchestratorCmd(),
		customizeCmd(),
		packCmd(),
	)

	return rootCmd.Execute()
}
