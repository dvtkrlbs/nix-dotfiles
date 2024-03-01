{}: { 
  rust_fenix_precommit = {
    path = ./rust_fenix_precommit;
    description = "Rust flake using fenix for ease of multi-targeting and pre-commit hooks";
  };

  go_precommit = {
    path = ./go_precommit;
    description = "Go flake using pre-commit hooks";
  };

  nodejs_precommit = {
    path = ./nodejs_precommit;
    description = "Node.js flake using pre-commit hooks";
  };
}