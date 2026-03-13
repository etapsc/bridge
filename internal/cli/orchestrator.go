package cli

import (
	"fmt"

	"github.com/spf13/cobra"
)

func orchestratorCmd() *cobra.Command {
	var orchType, platform, target string

	cmd := &cobra.Command{
		Use:   "orchestrator",
		Short: "Install controller or multi-repo orchestrator",
		Long:  "Install BRIDGE Controller (portfolio management) or Multi-Repo (cross-repo coding) orchestrator packs.",
		RunE: func(cmd *cobra.Command, args []string) error {
			// TODO: S21 — implement orchestrator install
			fmt.Println("bridge orchestrator — not yet implemented")
			fmt.Printf("  type: %s, platform: %s, target: %s\n", orchType, platform, target)
			return nil
		},
	}

	cmd.Flags().StringVar(&orchType, "type", "", "Orchestrator type: controller, multi-repo, both")
	cmd.Flags().StringVar(&platform, "platform", "claude-code", "Platform for multi-repo: claude-code, codex")
	cmd.Flags().StringVarP(&target, "target", "t", ".", "Target directory")

	return cmd
}
