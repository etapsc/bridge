package cli

import (
	"fmt"
	"os"

	"github.com/etapsc/bridge/internal/tui"
	"github.com/spf13/cobra"
)

func Execute(version string) error {
	rootCmd := &cobra.Command{
		Use:     "bridge",
		Short:   "BRIDGE — structured development workflow for AI coding agents",
		Long:    "BRIDGE v3 — Brainstorm → Requirements → Implementation Design → Develop → Gate → Evaluate.\nInteractive TUI for project setup, customization, and pack management.",
		Version: version,
		RunE: func(cmd *cobra.Command, args []string) error {
			// No subcommand provided — launch interactive TUI
			action, err := tui.SelectAction()
			if err != nil {
				return err
			}

			switch action {
			case tui.ActionNew:
				form, err := tui.RunNewProjectForm()
				if err != nil {
					return err
				}
				// Build args and run new command
				newArgs := []string{"new", "--name", form.Name, "--pack", form.Pack, "--personality", form.Personality, "--output", form.Output}
				for _, s := range form.Specializations {
					newArgs = append(newArgs, "--spec", s)
				}
				cmd.Root().SetArgs(newArgs)
				return cmd.Root().Execute()

			case tui.ActionAdd:
				fmt.Println("Launching add workflow...")
				cmd.Root().SetArgs([]string{"add"})
				return cmd.Root().Execute()

			case tui.ActionOrchestrator:
				fmt.Println("Launching orchestrator workflow...")
				cmd.Root().SetArgs([]string{"orchestrator"})
				return cmd.Root().Execute()

			case tui.ActionCustomize:
				fmt.Println("Launching customize workflow...")
				cmd.Root().SetArgs([]string{"customize", "--list"})
				return cmd.Root().Execute()

			case tui.ActionPack:
				cmd.Root().SetArgs([]string{"pack"})
				return cmd.Root().Execute()
			}

			return nil
		},
	}

	// Silence usage on errors from RunE
	rootCmd.SilenceUsage = true
	// Only show usage when explicitly requested (--help)
	rootCmd.SilenceErrors = true

	rootCmd.AddCommand(
		newCmd(),
		addCmd(),
		orchestratorCmd(),
		customizeCmd(),
		packCmd(),
	)

	err := rootCmd.Execute()
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error: %v\n", err)
		os.Exit(1)
	}
	return nil
}
