package cli

import (
	"fmt"

	"github.com/spf13/cobra"
)

func newCmd() *cobra.Command {
	var name, pack, personality, output string
	var specs []string

	cmd := &cobra.Command{
		Use:   "new",
		Short: "Create a new project with BRIDGE tooling",
		Long:  "Create a new project directory with BRIDGE methodology pack, personality, and domain specializations.",
		RunE: func(cmd *cobra.Command, args []string) error {
			// TODO: S16 — implement project creation
			// If no flags provided, launch TUI (S20)
			fmt.Println("bridge new — not yet implemented")
			fmt.Printf("  pack: %s, name: %s, personality: %s, specs: %v, output: %s\n", pack, name, personality, specs, output)
			return nil
		},
	}

	cmd.Flags().StringVarP(&name, "name", "n", "", "Project name")
	cmd.Flags().StringVarP(&pack, "pack", "p", "", "Pack: full, standalone, claude-code, codex, opencode")
	cmd.Flags().StringVar(&personality, "personality", "balanced", "Personality: strict, balanced, mentoring")
	cmd.Flags().StringSliceVar(&specs, "spec", nil, "Domain specializations: frontend, backend, api, data, infra, mobile, security")
	cmd.Flags().StringVarP(&output, "output", "o", ".", "Output parent directory")

	return cmd
}
