# Java Toolchain

Java is managed through Arch Linux packages. SDKMAN is not part of the managed
toolchain.

## JDKs

`home/.packages.yaml` installs these development kits:

- `jdk17-openjdk` -> `/usr/lib/jvm/java-17-openjdk`
- `jdk21-openjdk` -> `/usr/lib/jvm/java-21-openjdk`
- `jdk25-openjdk` -> `/usr/lib/jvm/java-25-openjdk`

`home/.chezmoiscripts/linux/run_onchange_after_00-install-packages.sh.tmpl`
selects `java-21-openjdk` as the system default with `archlinux-java` after
package installation. The shell does not prepend a private Java installation to
`PATH`; `java`, `javac`, and related tools resolve through the Arch Java
environment.

Useful checks:

```bash
archlinux-java status
archlinux-java get
java -version
javac -version
```

## Neovim

Java language support is split between the generic LSP configuration and the
Java-specific plugin:

- `home/dot_config/nvim/lua/plugins/jdtls.lua` loads `nvim-jdtls` for Java
  buffers.
- `home/dot_config/nvim/lua/configs/lspconfig.lua` enables `jdtls` and
  `gradle_ls`.
- JDTLS uses Java 21 as its home runtime and advertises Java 17, 21, and 25
  runtimes from `/usr/lib/jvm`.
- Lombok is attached from Mason's JDTLS package through `JDTLS_JVM_ARGS`.
- Java debug and test bundles are discovered from Mason's
  `java-debug-adapter` and `java-test` package directories.
- JDTLS formatting uses `~/eclipse-my-style.xml` with the `Eclipse`
  formatter profile.

The repository configures these Mason-backed tools but does not currently
declare their installation. A clean machine therefore needs the corresponding
Mason packages before every optional Java integration is available:

- `jdtls`
- `java-debug-adapter`
- `java-test`
- `gradle-language-server`

`home/eclipse-java-google-style.xml` is also managed, but the active JDTLS
configuration does not reference it.

## OpenCode

`home/dot_config/opencode/private_opencode.json.tmpl` configures Java through
the same Mason JDTLS installation used by Neovim. It:

- launches Mason's `jdtls`;
- injects the Mason Lombok agent;
- uses Java 21 as the primary JDTLS runtime;
- advertises Java 17, 21, and 25 from `/usr/lib/jvm`;
- enables the existing JDTLS Java settings for sources, code lenses, inlay
  hints, null analysis, Maven source downloads, and formatting;
- configures `gradle-language-server` for `.gradle` and `.gradle.kts`.

Restart OpenCode after changing the rendered configuration.

## Gradle and Maven Neovim plugins

The repository still contains disabled historical plugins:

- `home/dot_config/nvim/lua/plugins_archived/gradle.lua`
- `home/dot_config/nvim/lua/plugins_archived/maven.lua`

They are archived and disabled; they are not part of the active Java workflow.

## Java archives

`home/dot_config/mimeapps.list` maps `application/java-archive` files to
`xarchiver.desktop`.

## SDKMAN migration

SDKMAN installation, shell initialization, Java candidate paths, and Java
version metadata have been removed from the managed dotfiles.

An existing `~/.sdkman` directory is intentionally left untouched because it
is unmanaged user data and may contain SDKs unrelated to Java. If it contains
nothing you want to keep, remove it manually after verifying the Arch JDKs:

```bash
archlinux-java status
rm -rf ~/.sdkman
```
