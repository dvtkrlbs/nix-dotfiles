{
  rust = {
    path = ./rust;
    description = "Rust flake using fenix for ease of multi-targeting and pre-commit hooks";
  };

  go = {
    path = ./go;
    description = "Go flake using pre-commit hooks";
  };

  node = {
    path = ./node;
    description = "Node.js flake using pre-commit hooks";
  };

  cpp = {
    path = ./cpp;
    description = "Cpp flake";
  };

  elixir = {
    path = ./elixir;
    description = "Elixir flake";
  };

  scala = {
    path = ./scala;
    description = "Scala flake";
  };
}
