package config

import (
	"errors"
	"os"
	"path/filepath"

	homedir "github.com/mitchellh/go-homedir"
)

var ConfigDir string

// InitConfigDir finds the configuration directory for macro according to the XDG spec.
// If no directory is found, it creates one.
func InitConfigDir(flagConfigDir string) error {
	var e error

	macroHome := os.Getenv("MACRO_CONFIG_HOME")
	if macroHome == "" {
		// The user has not set $MACRO_CONFIG_HOME so we'll try $XDG_CONFIG_HOME
		xdgHome := os.Getenv("XDG_CONFIG_HOME")
		if xdgHome == "" {
			// The user has not set $XDG_CONFIG_HOME so we should act like it was set to ~/.config
			home, err := homedir.Dir()
			if err != nil {
				return errors.New("Error finding your home directory\nCan't load config files: " + err.Error())
			}
			xdgHome = filepath.Join(home, ".config")
		}

		macroHome = filepath.Join(xdgHome, "macro")
	}
	ConfigDir = macroHome

	if len(flagConfigDir) > 0 {
		if _, err := os.Stat(flagConfigDir); os.IsNotExist(err) {
			e = errors.New("Error: " + flagConfigDir + " does not exist. Defaulting to " + ConfigDir + ".")
		} else {
			ConfigDir = flagConfigDir
			return nil
		}
	}

	// Create macro config home directory if it does not exist
	// This creates parent directories and does nothing if it already exists
	err := os.MkdirAll(ConfigDir, os.ModePerm)
	if err != nil {
		return errors.New("Error creating configuration directory: " + err.Error())
	}

	return e
}
