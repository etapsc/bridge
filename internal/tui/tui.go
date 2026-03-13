package tui

import (
	"fmt"

	"github.com/charmbracelet/huh"
	"github.com/charmbracelet/lipgloss"
)

var (
	titleStyle = lipgloss.NewStyle().Bold(true).Foreground(lipgloss.Color("12"))
)

// Action represents the top-level menu choice.
type Action string

const (
	ActionNew          Action = "new"
	ActionAdd          Action = "add"
	ActionOrchestrator Action = "orchestrator"
	ActionCustomize    Action = "customize"
	ActionPack         Action = "pack"
)

// SelectAction shows the main menu and returns the selected action.
func SelectAction() (Action, error) {
	var action Action
	err := huh.NewForm(
		huh.NewGroup(
			huh.NewSelect[Action]().
				Title(titleStyle.Render("BRIDGE v3")).
				Description("What would you like to do?").
				Options(
					huh.NewOption("New project", ActionNew),
					huh.NewOption("Add to existing project", ActionAdd),
					huh.NewOption("Install orchestrator", ActionOrchestrator),
					huh.NewOption("Customize project", ActionCustomize),
					huh.NewOption("Pack archives (maintainer)", ActionPack),
				).
				Value(&action),
		),
	).Run()

	return action, err
}

// NewProjectForm collects inputs for creating a new project.
type NewProjectForm struct {
	Name            string
	Pack            string
	Personality     string
	Specializations []string
	Output          string
}

func RunNewProjectForm() (*NewProjectForm, error) {
	f := &NewProjectForm{Output: "."}

	err := huh.NewForm(
		huh.NewGroup(
			huh.NewSelect[string]().
				Title("Platform pack").
				Options(
					huh.NewOption("Claude Code", "claude-code"),
					huh.NewOption("Codex", "codex"),
					huh.NewOption("RooCode Full", "full"),
					huh.NewOption("RooCode Standalone", "standalone"),
					huh.NewOption("OpenCode", "opencode"),
				).
				Value(&f.Pack),

			huh.NewSelect[string]().
				Title("Personality").
				Options(
					huh.NewOption("strict — rigorous, skeptical, evidence-demanding", "strict"),
					huh.NewOption("balanced — pragmatic, trade-off conscious (default)", "balanced"),
					huh.NewOption("mentoring — explanatory, patient, educational", "mentoring"),
				).
				Value(&f.Personality),

			huh.NewMultiSelect[string]().
				Title("Domain specializations (space to toggle)").
				Options(
					huh.NewOption("Frontend", "frontend"),
					huh.NewOption("Backend", "backend"),
					huh.NewOption("API", "api"),
					huh.NewOption("Data", "data"),
					huh.NewOption("Infrastructure", "infra"),
					huh.NewOption("Mobile", "mobile"),
					huh.NewOption("Security", "security"),
				).
				Value(&f.Specializations),
		),
		huh.NewGroup(
			huh.NewInput().
				Title("Project name").
				Prompt("> ").
				Value(&f.Name).
				Validate(func(s string) error {
					if s == "" {
						return fmt.Errorf("project name is required")
					}
					return nil
				}),

			huh.NewInput().
				Title("Output directory").
				Prompt("> ").
				Value(&f.Output),
		),
	).Run()

	return f, err
}

// CustomizeForm collects inputs for customizing an existing project.
type CustomizeForm struct {
	Personality     string
	AddSpecs        []string
	RemoveSpecs     []string
}

func RunCustomizeForm(currentPersonality string, currentSpecs []string) (*CustomizeForm, error) {
	f := &CustomizeForm{Personality: currentPersonality}

	err := huh.NewForm(
		huh.NewGroup(
			huh.NewSelect[string]().
				Title("Personality").
				Options(
					huh.NewOption("strict — rigorous, skeptical, evidence-demanding", "strict"),
					huh.NewOption("balanced — pragmatic, trade-off conscious", "balanced"),
					huh.NewOption("mentoring — explanatory, patient, educational", "mentoring"),
				).
				Value(&f.Personality),

			huh.NewMultiSelect[string]().
				Title("Add specializations").
				Options(
					huh.NewOption("Frontend", "frontend"),
					huh.NewOption("Backend", "backend"),
					huh.NewOption("API", "api"),
					huh.NewOption("Data", "data"),
					huh.NewOption("Infrastructure", "infra"),
					huh.NewOption("Mobile", "mobile"),
					huh.NewOption("Security", "security"),
				).
				Value(&f.AddSpecs),
		),
	).Run()

	return f, err
}
