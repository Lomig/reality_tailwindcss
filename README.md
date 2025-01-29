# RealityTailwindCSS

**RealityTailwindCSS** is a utility designed to simplify the integration of TailwindCSS into OCaml/Dream web projects. It automates the download of the TailwindCSS standalone CLI and sets up Dune rules for building CSS during the `dune build` process.

## Features

- **Download TailwindCSS CLI**: Automatically downloads the correct version of the TailwindCSS standalone CLI.
- **Dune Integration**: Adds Dune rules to handle the download of the TailwindCSS CLI and the generation of CSS files.
- **Project Setup**: Creates the necessary directory structure and initial CSS file for your project.

## Installation

To use RealityTailwindCSS in your OCaml/Dream project, follow these steps:

1. **Add the Dependency**:
   Add `reality_tailwindcss` to your `dune-project` file or `opam` dependencies.

   ```opam
   opam install reality_tailwindcss
   ```

2. **Install and Set Up**:
   Run the `reality_tailwindcss install` command to set up the necessary Dune rules, create the target directory for CSS, and generate the initial CSS file.

   ```bash
   reality_tailwindcss install
   ```

   This will:
   - Add Dune rules for downloading the TailwindCSS CLI and building CSS.
   - Create a `static/` directory for the generated CSS.
   - Create a `lib/client/stylesheets/application.css` file as the source for your TailwindCSS styles.

## Usage

After installation, your project will automatically build the CSS files whenever you run `dune build`. The generated CSS will be placed in the `static/` directory, ready to be served by your Dream application.

### Customizing TailwindCSS

To customize TailwindCSS, edit the `lib/client/stylesheets/application.css` file. You can add custom styles or modify the Tailwind configuration as needed.

Based on Tailwind 4.0, the configuration is CSS-only and allows for local CSS imports.

```css
@import "tailwindcss";
@import "./other_css_file.css";

/* Add your custom styles here */
```

## Example Project Structure

After running `reality_tailwindcss install`, your project structure should look something like this:

```
.
├── dune-project
├── build
|   └── default
|       └── bin
|           └── tailwindcss
├── bin
|   └── dune
├── lib
│   └── client
│       └── stylesheets
│           └── application.css
└── static
    └── application.css
```

## Contributing

Contributions are welcome! If you have any suggestions, bug reports, or feature requests, please open an issue or submit a pull request.

## License

This project is licensed under the **GNU General Public License v3.0 (GPL-3.0)**. See the [LICENSE](LICENSE) file for more details.
