import Config

root_dir = File.cwd!()

config :servy, about_path: Path.join(root_dir, "pages/about.html")
config :servy, pages_path: Path.join(root_dir, "pages/")
config :servy, bear_form_path: Path.join(root_dir, "pages/bear_form.html")
config :servy, bears_templates_path: Path.join(root_dir, "templates/bears")
config :servy, lions_templates_path: Path.join(root_dir, "templates/lions")
