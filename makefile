# Makefile for installing DevOps tools

# --- Configuration Variables ---
# Versions to install
TERRAFORM_VERSION := 1.11.1
TERRAGRUNT_VERSION := 0.75.3
KUBECTL_VERSION := 1.32.5
HELM_VERSION := 3.17.1
ARGOCD_VERSION := 2.14.9
IONOS_CLI_VERSION := latest

# Installation paths
LOCAL_BIN := $(HOME)/.local/bin
PATH := $(PATH):$(LOCAL_BIN)

# --- OS Detection ---
UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Linux)
    OS_TYPE := linux
    # Detect Linux distribution for package manager
    ifneq ($(shell which apt-get),)
        PKG_MANAGER := apt
    else ifneq ($(shell which yum),)
        PKG_MANAGER := yum
    else ifneq ($(shell which dnf),)
        PKG_MANAGER := dnf
    else
        PKG_MANAGER := unknown
    endif
else ifeq ($(UNAME_S),Darwin)
    OS_TYPE := darwin
    PKG_MANAGER := brew
else
    OS_TYPE := unknown
endif

# --- Helper Functions ---
define check_os_and_pkg_manager
	@echo "Detected OS: $(OS_TYPE)"
	@echo "Detected Package Manager: $(PKG_MANAGER)"
	@if [ "$(OS_TYPE)" = "unknown" ]; then \
		echo "Error: Unsupported OS. This Makefile supports Linux (Debian/RHEL) and macOS."; \
		exit 1; \
	fi
	@if [ "$(PKG_MANAGER)" = "unknown" ] && [ "$(OS_TYPE)" = "linux" ]; then \
		echo "Error: Unsupported Linux distribution. Please install required dependencies manually."; \
		exit 1; \
	fi
endef

define install_pipx
	@echo "Installing pipx..."
	@if [ "$(OS_TYPE)" = "linux" ]; then \
		if [ "$(PKG_MANAGER)" = "apt" ]; then \
			sudo apt-get update && sudo apt-get install -y python3-pip python3-venv; \
		else if [ "$(PKG_MANAGER)" = "yum" ] || [ "$(PKG_MANAGER)" = "dnf" ]; then \
			sudo yum install -y python3-pip python3-venv || sudo dnf install -y python3-pip python3-venv; \
		fi; \
	else if [ "$(OS_TYPE)" = "darwin" ]; then \
		brew install pipx; \
	fi; \
	python3 -m pip install --user pipx; \
	python3 -m pipx ensurepath; \
	echo "pipx installed. You may need to restart your shell or run 'source ~/.bashrc'/'source ~/.zshrc' to update PATH.";
endef

# --- General Targets ---
.PHONY: all clean help

all: install-terraform install-terragrunt install-ionos-cli install-kubectl install-helm install-argocd
	@echo "All specified tools installed."
	@echo "Please ensure $(LOCAL_BIN) is in your PATH. You might need to restart your shell."

clean:
	@echo "This Makefile does not support uninstallation. Please remove binaries manually from $(LOCAL_BIN)."

help:
	@echo "Usage: make <target>"
	@echo ""
	@echo "Targets:"
	@echo "  all                 - Install all tools (terraform, terragrunt, ionos-cli, kubectl, helm, argocd)."
	@echo "  install-terraform   - Install Terraform."
	@echo "  install-terragrunt  - Install Terragrunt."
	@echo "  install-ionos-cli   - Install IONOS CLI."
	@echo "  install-kubectl     - Install kubectl (Kubernetes CLI)."
	@echo "  install-helm        - Install Helm."
	@echo "  install-argocd      - Install ArgoCD CLI."
	@echo "  clean               - (Placeholder) This Makefile does not support uninstallation."
	@echo "  help                - Display this help message."
	@echo ""
	@echo "Ensure you have sudo privileges and internet access."
	@echo "For Linux, ensure your package manager is apt, yum, or dnf."
	@echo "For macOS, ensure Homebrew is installed."

# --- Installation Targets ---

install-terraform:
	$(call check_os_and_pkg_manager)
	@echo "Installing Terraform $(TERRAFORM_VERSION)..."
	@mkdir -p $(LOCAL_BIN)
	@if [ "$(OS_TYPE)" = "linux" ]; then \
		curl -LO "