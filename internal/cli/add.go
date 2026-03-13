package cli

import (
	"fmt"

	"github.com/spf13/cobra"
)

func addCmd() *cobra.Command {
	var name, pack, personality, target string
	var specs []string

	cmd := &cobra.Command{
		Use:   "add",
		Short: "Add BRIDGE tooling to an existing project",
		Long:  "Install BRIDGE methodology pack into an existing project directory without overwriting protected files.",
		RunE: func(cmd *cobra.Command, args []string) error {
			// TODO: S17 — implement add-to-existing
			fmt.Println("bridge add — not yet implemented")
			fmt.Printf("  pack: %s, name: %s, personality: %s, specs: %v, target: %s\n", pack, name, personality, specs, target)
			return nil
		},
	}

	cmd.Flags().StringVarP(&name, "name", "n", "", "Project name")
	cmd.Flags().StringVarP(&pack, "pack", "p", "", "Pack: full, standalone, claude-code, codex, opencode, dual-agent")
	cmd.Flags().StringVar(&personality, "personality", "balanced", "Personality: strict, balanced, mentoring")
	cmd.Flags().StringSliceVar(&specs, "spec", nil, "Domain specializations")
	cmd.Flags().StringVarP(&target, "target", "t", ".", "Target project directory")

	return cmd
}
