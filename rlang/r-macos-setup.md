# R Setup for macOS (aarch64 / Apple Silicon / Homebrew)

Tested on: R 4.5.3, macOS Sonoma (darwin23), Homebrew at /opt/homebrew

---

## 1. Homebrew packages

```bash
brew install \
  libomp \
  openssl@3 \
  libxml2 \
  curl \
  gettext \
  pkg-config \
  hdf5 \
  udunits \
  proj \
  geos \
  gdal \
  gfortran \
  libpq \
  unixodbc \
  imagemagick \
  cairo \
  libsodium \
  v8
```

---

## 2. The llvm/libomp symlink (permanent infrastructure)

Homebrew's R compiles bundled packages (including `rlang`) against
`/opt/homebrew/opt/llvm/lib/libomp.dylib`. This path is hardcoded in
those `.so` files. Since `llvm` itself is not installed, the directory
doesn't exist — create the symlink once and leave it:

```bash
mkdir -p /opt/homebrew/opt/llvm/lib
ln -sf /opt/homebrew/opt/libomp/lib/libomp.dylib \
       /opt/homebrew/opt/llvm/lib/libomp.dylib
```

This is not a hack — it's compensating for a Homebrew R packaging
assumption. It will be needed after any `brew upgrade r` that ships
a new bundled `rlang.so`.

---

## 3. ~/.Renviron

```sh
R_LIBS_USER=~/.R/libs
R_LIBS_SITE=
```

`R_LIBS_SITE=` (empty) prevents R from picking up stale packages in
`/opt/homebrew/lib/R/4.5/site-library/`. All packages go in `~/.R/libs`.

---

## 4. ~/.R/Makevars

```make
# Compiler flags (Apple Clang + standalone libomp)
CFLAGS=-O2 -Xpreprocessor -fopenmp -I/opt/homebrew/opt/libomp/include
CXXFLAGS=-O2 -Xpreprocessor -fopenmp -I/opt/homebrew/opt/libomp/include
SHLIB_OPENMP_CFLAGS=-Xpreprocessor -fopenmp -I/opt/homebrew/opt/libomp/include
SHLIB_OPENMP_CXXFLAGS=-Xpreprocessor -fopenmp -I/opt/homebrew/opt/libomp/include

# Parallel builds
MAKEFLAGS = -j8

# Include paths (keg-only packages need explicit paths)
CPPFLAGS=-I/opt/homebrew/include \
         -I/opt/homebrew/opt/libomp/include \
         -I/opt/homebrew/opt/libxml2/include \
         -I/opt/homebrew/opt/curl/include \
         -I/opt/homebrew/opt/gettext/include \
         -I/opt/homebrew/opt/openssl@3/include

# Linker flags
LDFLAGS=-L/opt/homebrew/lib \
        -L/opt/homebrew/opt/libomp/lib -lomp \
        -L/opt/homebrew/opt/libxml2/lib \
        -L/opt/homebrew/opt/curl/lib \
        -L/opt/homebrew/opt/gettext/lib \
        -L/opt/homebrew/opt/openssl@3/lib
```

---

## 5. PKG_CONFIG_PATH (add to ~/.zshrc or ~/.zprofile)

`libxml2` is keg-only and its `.pc` file is not on the default
pkg-config search path. Fix:

```bash
export PKG_CONFIG_PATH="/opt/homebrew/opt/libxml2/lib/pkgconfig:\
/opt/homebrew/opt/curl/lib/pkgconfig:\
/opt/homebrew/opt/openssl@3/lib/pkgconfig:\
$PKG_CONFIG_PATH"
```

---

## 6. ~/.Rprofile

```r
# Ensure user library exists
dir.create(Sys.getenv("R_LIBS_USER"), recursive = TRUE, showWarnings = FALSE)

# CRAN mirror (Posit Package Manager for fast binaries)
local({
  r <- getOption("repos")
  r["CRAN"] <- "https://packagemanager.posit.co/cran/latest/"
  options(repos = r)
  options(digits.secs = 5)
  options(scipen = 999)
  options(help_type = "html")
  options(setWidthOnResize = TRUE)
  options(pkg.num_workers = 2)  # prevent pak subprocess crashes
})

# GitHub PAT from gh CLI (keeps in sync with gh auth)
Sys.setenv(GITHUB_PAT = system("gh auth token 2>/dev/null", intern = TRUE))
```

---

## 7. GitHub credentials

Run once interactively to store token in macOS Keychain:

```r
gitcreds::gitcreds_set()
# paste output of: gh auth token
```

---

## 8. After brew upgrade r

Homebrew will replace the R Cellar directory, which resets the bundled
`rlang.so` to one compiled against the llvm path. The symlink from
step 2 handles this automatically — but if you see:

```
Library not loaded: /opt/homebrew/opt/llvm/lib/libomp.dylib
```

Check the symlink still exists:

```bash
ls -la /opt/homebrew/opt/llvm/lib/libomp.dylib
```

And reinstall rlang into your user library to get a fresh copy:

```r
pak::pak("rlang")
```

---

## 9. Notes on keg-only packages

These Homebrew packages are "keg-only" (not symlinked into
`/opt/homebrew`) because macOS ships its own versions:

| Package    | Why keg-only              |
|------------|---------------------------|
| `curl`     | macOS ships curl          |
| `libxml2`  | macOS ships libxml2       |
| `openssl@3`| macOS ships LibreSSL      |
| `gettext`  | macOS ships older gettext |
| `libomp`   | No macOS equivalent       |

The explicit paths in `Makevars` (step 4) and `PKG_CONFIG_PATH`
(step 5) are the permanent fix for all of these.
