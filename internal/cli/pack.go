package cli

import (
	"fmt"

	"github.com/spf13/cobra"
)

func packCmd() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "pack",
		Short: "Build release tar.gz archives (maintainer tool)",
		Long:  "Rebuild all distributable pack archives from source folders. Equivalent to the legacy package.sh script.",
		RunE: func(cmd *cobra.Command, args []string) error {
			// TODO: S21 — implement pack builder
			fmt.Println("bridge pack — not yet implemented")
			return nil
		},
	}

	return cmd
}
