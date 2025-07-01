# Makefile for installing DevOps tools

# --- Configuration Variables ---
# Versions to install
TERRAFORM_VERSION := 1.11.1
TERRAGRUNT_VERSION := 0.75.3
KUBECTL_VERSION := 1.32.5
HELM_VERSION := 3.17.1
ARGOCD_VERSION := 2.14.9
IONOS_CLI_VERSION := 6.8.5

# Installation paths
LOCAL_BIN := $(HOME)/.local/bin
PATH := $(PATH):$(LOCAL_BIN)

# --- OS Detection ---
UNAME_S_RAW := $(shell uname -s)
# Convert to lowercase and trim whitespace for robust comparison
UNAME_S := $(shell echo $(UNAME_S_RAW) | tr '[:upper:]' '[:lower:]' | xargs)

ifeq ($(UNAME_S),linux)
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
else ifeq ($(UNAME_S),darwin)
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
		echo "Error: Unsupported OS. This Makefile supports Linux (Debian/RHEL derivatives) and macOS."; \
		exit 1; \
	fi
	@if [ "$(PKG_MANAGER)" = "unknown" ] && [ "$(OS_TYPE)" = "linux" ]; then \
		echo "Error: Unsupported Linux distribution. Please install required dependencies manually or update your system."; \
		exit 1; \
	fi
endef

define install_pipx
	@echo "Installing pipx..."
	@if [ "$(OS_TYPE)" = "linux" ]; then \
		if [ "$(PKG_MANAGER)" = "apt" ]; then \
			sudo apt-get update && sudo apt-get install -y python3-pip python3-venv; \
		elif [ "$(PKG_MANAGER)" = "yum" ] || [ "$(PKG_MANAGER)" = "dnf" ]; then \
			sudo yum install -y python3-pip python3-venv || sudo dnf install -y python3-pip python3-venv; \
		else \
			echo "Warning: pipx prerequisites may need manual installation for this Linux distribution."; \
		fi; \
	elif [ "$(OS_TYPE)" = "darwin" ]; then \
		if ! command -v brew &> /dev/null; then \
			echo "Error: Homebrew is required on macOS to install pipx prerequisites. Please install Homebrew first (brew.sh)."; \
			exit 1; \
		fi; \
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
	@echo "You can verify installations by running e.g., 'terraform --version'."

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
		curl -LO "https://releases.hashicorp.com/terraform/$(TERRAFORM_VERSION)/terraform_$(TERRAFORM_VERSION)_linux_amd64.zip"; \
		unzip -o "terraform_$(TERRAFORM_VERSION)_linux_amd64.zip" -d $(LOCAL_BIN); \
		rm "terraform_$(TERRAFORM_VERSION)_linux_amd64.zip"; \
	elif [ "$(OS_TYPE)" = "darwin" ]; then \
		if ! command -v brew &> /dev/null; then \
			echo "Error: Homebrew is required on macOS to install Terraform. Please install Homebrew first (brew.sh)."; \
			exit 1; \
		fi; \
		brew install terraform; \
	else \
		echo "Error: Terraform installation not supported for this OS."; \
		exit 1; \
	fi
	@terraform version # Verify installation

install-terragrunt:
	$(call check_os_and_pkg_manager)
	@echo "Installing Terragrunt $(TERRAGRUNT_VERSION)..."
	@mkdir -p $(LOCAL_BIN)
	@if [ "$(OS_TYPE)" = "linux" ]; then \
		curl -LO "https://github.com/gruntwork-io/terragrunt/releases/download/v$(TERRAGRUNT_VERSION)/terragrunt_linux_amd64"; \
		chmod +x terragrunt_linux_amd64; \
		mv terragrunt_linux_amd64 $(LOCAL_BIN)/terragrunt; \
	elif [ "$(OS_TYPE)" = "darwin" ]; then \
		if ! command -v brew &> /dev/null; then \
			echo "Error: Homebrew is required on macOS to install Terragrunt. Please install Homebrew first (brew.sh)."; \
			exit 1; \
		fi; \
		brew install terragrunt; \
	else \
		echo "Error: Terragrunt installation not supported for this OS."; \
		exit 1; \
	fi
	@terragrunt --version # Verify installation

install-ionos-cli:
	$(call check_os_and_pkg_manager)
	@echo "Installing IONOS CLI $(IONOS_CLI_VERSION)..."
	$(call install_pipx)
	@python3 -m pipx install "ionoscli$(if $(filter latest,$(IONOS_CLI_VERSION)),,==$(IONOS_CLI_VERSION))" || \
	(echo "Warning: pipx installation failed or already installed. Trying with pip (not recommended for CLIs)."; \
	 python3 -m pip install "ionoscli$(if $(filter latest,$(IONOS_CLI_VERSION)),,==$(IONOS_CLI_VERSION))")
	@ionos --version # Verify installation

install-kubectl:
	$(call check_os_and_pkg_manager)
	@echo "Installing kubectl $(KUBECTL_VERSION)..."
	@mkdir -p $(LOCAL_BIN)
	@if [ "$(OS_TYPE)" = "linux" ]; then \
		curl -LO "https://dl.k8s.io/release/v$(KUBECTL_VERSION)/bin/linux/amd64/kubectl"; \
		chmod +x kubectl; \
		mv kubectl $(LOCAL_BIN)/kubectl; \
	elif [ "$(OS_TYPE)" = "darwin" ]; then \
		if ! command -v brew &> /dev/null; then \
			echo "Error: Homebrew is required on macOS to install kubectl. Please install Homebrew first (brew.sh)."; \
			exit 1; \
		fi; \
		brew install kubectl; \
	else \
		echo "Error: kubectl installation not supported for this OS."; \
		exit 1; \
	fi
	@kubectl version --client # Verify installation

install-helm:
	$(call check_os_and_pkg_manager)
	@echo "Installing Helm $(HELM_VERSION)..."
	@mkdir -p $(LOCAL_BIN)
	@if [ "$(OS_TYPE)" = "linux" ]; then \
		curl -fsSL https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | DESIRED_VERSION=v$(HELM_VERSION) bash -s -- -d $(LOCAL_BIN); \
	elif [ "$(OS_TYPE)" = "darwin" ]; then \
		if ! command -v brew &> /dev/null; then \
			echo "Error: Homebrew is required on macOS to install Helm. Please install Homebrew first (brew.sh)."; \
			exit 1; \
		fi; \
		brew install helm; \
	else \
		echo "Error: Helm installation not supported for this OS."; \
		exit 1; \
	fi
	@helm version # Verify installation

install-argocd:
	$(call check_os_and_pkg_manager)
	@echo "Installing ArgoCD CLI $(ARGOCD_VERSION)..."
	@mkdir -p $(LOCAL_BIN)
	@if [ "$(OS_TYPE)" = "linux" ]; then \
		curl -sSL -o $(LOCAL_BIN)/argocd https://github.com/argoproj/argo-cd/releases/download/v$(ARGOCD_VERSION)/argocd-linux-amd64; \
		chmod +x $(LOCAL_BIN)/argocd; \
	elif [ "$(OS_TYPE)" = "darwin" ]; then \
		if ! command -v brew &> /dev/null; then \
			echo "Error: Homebrew is required on macOS to install ArgoCD CLI. Please install Homebrew first (brew.sh)."; \
			exit 1; \
		fi; \
		brew install argocd; \
	else \
		echo "Error: ArgoCD CLI installation not supported for this OS."; \
		exit 1; \
	fi
	@argocd version --client # Verify installation