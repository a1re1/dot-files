package main

import (
	"fmt"
	"os"
	"os/exec"
	"strconv"

	"github.com/charmbracelet/huh"
	"github.com/charmbracelet/huh/spinner"
	"github.com/charmbracelet/lipgloss"
)

func main() {
	accessible, _ := strconv.ParseBool(os.Getenv("ACCESSIBLE"))

	var tools []string

	huh.NewMultiSelect[string]().
		Title("Choose tools").
		Options(
			huh.NewOption("Elixir Pheonix", "elixir-pheonix"),
			huh.NewOption("Blossom", "blossom"),
		).
		Value(&tools).
		WithAccessible(accessible).
		Run()

	runShellScript := func(cmd string, cmdArgs ...string) {
		fmt.Println("🛠️ running: ", cmd, " with args: ", cmdArgs)
		stdout, err := exec.Command(cmd, cmdArgs...).Output()
		fmt.Printf("output: %s", string(stdout))
		if err != nil {
			fmt.Printf("error %s", err)
		}
	}

	runWithLoading := func(cmd string, args ...string) {
		runnable := func() {
			runShellScript(cmd, args...)
		}
		_ = spinner.New().Title("Generating modules...").Accessible(accessible).Action(runnable).Run()
	}

	for _, tool := range tools {
		if tool == "elixir-pheonix" {
			runWithLoading("sudo", "add-apt-repository", "ppa:rabbitmq/rabbitmq-erlang")
			runWithLoading("sudo", "apt", "update")
			runWithLoading("sudo", "apt", "install", "-y", "elixir", "erlang-dev", "erlang-xmerl")
			runWithLoading("sudo", "apt-get", "install", "-y", "inotify-tools")
			runWithLoading("sudo", "apt", "install", "-y", "postgresql")
			runWithLoading("sudo", "service", "postgresql", "start")
			runWithLoading("mix", "local.hex")
			runWithLoading("mix", "archive.install", "hex phx_new")
			runWithLoading("/bin/bash", "-c", "echo \"export PATH='$PATH:/usr/bin/elixir/bin'\" >> ~/.bashrc")
			fmt.Println("⚗️ Installed elixir and deps")
		}
		if tool == "blossom" {
			runWithLoading("git", "clone", "https://github.com/a1re1/blossom.git", "~/blossom/")
		}
	}

	{
		var str = "Success 🥳"
		fmt.Println("")
		fmt.Println(
			lipgloss.NewStyle().
				Width(32).
				BorderStyle(lipgloss.RoundedBorder()).
				BorderForeground(lipgloss.Color("63")).
				Padding(1, 2).
				Render(str),
		)
	}
}
