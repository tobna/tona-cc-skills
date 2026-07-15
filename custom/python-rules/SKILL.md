---
name: python-rules
description: Opinionated Python conventions — which tools to reach for, which idioms are current, and how much machinery a piece of code actually deserves. Use for any Python work: writing, editing, or reviewing code, setting up a project, or picking tooling and dependencies.
---

# Python rules

Defaults for a fresh project. **A repo's own settings win** — follow the repo, don't convert it.

**Simple and understandable beats every rule below.** Scale machinery to size: a 40-line script
needs no logger, no tests, no layout. Whether code should exist at all is `ponytail`'s call.

## Toolchain

| Job | Tool | Replaces |
|---|---|---|
| Packaging, venvs, Python installs, running | **uv** — always | pip, virtualenv, pipx, pyenv, poetry, conda |
| Lint + format + import sorting | **ruff** | black, flake8, isort, pyupgrade |
| Type check | **pyright** | mypy |
| Test | **pytest** | unittest |
| Logging | **loguru** | logging boilerplate |

`uv init` · `uv add torch` · `uv add --dev ruff pytest` · `uv run x.py` · `uv sync` · `uvx ruff check`

Never `pip install` into a system Python, never a hand-managed venv, never `requirements.txt` or
`setup.py`. Commit `uv.lock` (apps; libraries may skip). uv pins the Python version — any release
is fine. **`uv add` resolves versions — never hand-write a guessed one.** Constrain with
`>=MAJOR.MINOR`, not `==`; the lockfile does the pinning.

## Config — pyproject.toml only

`uv init` writes it; add the tool block. No `setup.cfg`/`.flake8`/`tox.ini`/`setup.py`.

```toml
[tool.ruff]
line-length = 120

[tool.ruff.lint]
select = ["E", "F", "I", "UP", "B", "SIM", "RUF"]   # +I = import sorting (isort)
ignore = ["E501"]                                   # the formatter owns line length
```

`ruff format` + `ruff check --fix` is the whole loop; `UP` auto-rewrites most of the table below.
`.gitignore` covers the toolchain's output (`__pycache__/`, `.venv/`, `.ruff_cache/`,
`.pytest_cache/`, `*.egg-info/`) — but **`uv.lock` is committed**. `src/` layout if installable.

## Syntax

- **f-strings** — `f"{acc:.2%}"`, `f"{x=}"` for debug. Never `.format`/`%`/`"a" + str(b)`.
- **pathlib** — `Path("d") / name`, `p.read_text()`, `p.glob("**/*.pt")`. Never `os.path`, never `open(str(p))`.
- **`list[int]`, `dict[str, X]`, `X | None`** — never `typing.List`/`Dict`/`Optional`/`Union`.
- **PEP 695** — `def first[T](xs: list[T]) -> T:`, `type Vec = list[float]`. No `TypeVar`+`Generic`.
- **dataclass** for records — `@dataclass(frozen=True, slots=True)`. Never a dict as an ad-hoc record, never an `__init__` that only assigns. pydantic only where validation is the point (external input, configs).
- **`enumerate` / `zip(..., strict=True)`** — never `range(len(xs))`; `strict` catches silent truncation.
- **`with`** for resources; `contextlib.suppress(...)` over `try/except/pass`.
- **EAFP over LBYL** — `try: d[k] / except KeyError:` beats a pre-check. Check first only for expensive pre-flight or hot loops.
- **`is None`, not truthiness** — `0`, `""`, `[]` are falsy, so `if x:` for "not None" is a bug.
- Comprehensions over `map`/`filter`/append-loops — but a `for` loop beats a 3-level nest.
- **`match`** only for real structural dispatch, not a dressed-up `if/elif`.
- **`if __name__ == "__main__":`** in anything runnable. No `global` for shared state — pass it in.
- **argparse** — booleans via `action=argparse.BooleanOptionalAction` (gives `--flag`/`--no-flag`). Never `type=bool` (`bool("False")` is `True`). `typer`/`tyro` only when the arg surface hurts.

## Type hints & docstrings

Optional — **match what the file already does**; consistency within a file beats coverage.

- Never `Any` (or `# type: ignore`) to silence pyright — narrow the type or fix the design.
- No mutable defaults: `x: list | None = None`, or `field(default_factory=list)`.
- When present, params **and** return together — a half-annotated signature is unchecked but looks typed.
- Skip locals; pyright infers them.
- If hints would genuinely help, **ask first**: this function, this file, or the repo? Then respect it.
- Docstrings on public API, in whatever style the project already uses. Skip the ones that restate the signature — a docstring re-listing the types is noise, not documentation.

## Modern Python

- **`@override`** (3.12+) on every method that overrides a base one — pyright then catches the base rename that would otherwise silently orphan it.
- **`Protocol`** for structural typing beats `isinstance` chains and ABCs — though one implementation means you didn't need the Protocol.
- **Annotations are lazy by default on 3.14+** (PEP 649), so `from __future__ import annotations` is dead weight there. Below 3.14, keep it for import cycles (with `TYPE_CHECKING`).
- **CPU parallelism is `multiprocessing`**; threads are for I/O. Free-threaded builds (`python3.13t`/`3.14t`) work, but the ecosystem is still catching up — one non-thread-safe C extension silently re-enables the GIL process-wide, so measure before believing it.
- **t-strings** (3.14, PEP 750) — the safe-interpolation primitive for SQL/HTML/shell, where the library supports them. Everywhere else f-strings still win.

## Errors, logging, I/O

- Specific exceptions; never bare `except:` or `except Exception: pass`. A custom exception class needs a caller that catches *it*.
- **`raise ... from e`** when re-raising, or the traceback is lost.
- **loguru** — `from loguru import logger`. No `getLogger`, no handler setup. Codebase already has logging? Use that.
- **f-strings in logs too** — `logger.info(f"loss {loss:.3f}")`; formatting a number is free. Defer only real compute, and only via `logger.opt(lazy=True).debug("{}", lambda: expensive(x))` — `logger.debug("{}", expensive(x))` defers nothing.
- **`print` is fine** in small scripts and for CLI output a human asked for.
- Validate untrusted input at the boundary (argv, files, network), then trust it inward. Never `eval`/`exec` on it; parameterize SQL, never string-build it.
- **JSON/CSV/parquet for data, never pickle** (version-fragile, executes code on load). `torch.save` for weights is fine.

## Debugging

- **`breakpoint()`** — never `import pdb; pdb.set_trace()`. Same thing, shorter, and `PYTHONBREAKPOINT=0` disables every one of them without an edit (`=ipdb.set_trace` swaps the debugger).
- **`pytest -x --pdb`** drops into a debugger at the first failure; `-l` shows locals in the traceback. Beats re-running with prints added.
- **Read tracebacks bottom-up**: the last line is what broke, and the lowest frame in *your* code is usually where to look.
- **`logger.exception(...)`** inside an `except` — or loguru's `@logger.catch` — records the traceback. `logger.error(str(e))` throws away the part you need.
- Reproduce on the smallest failing input before changing anything.
- Print-debugging a small script is fine; committing it isn't. Ruff's `T10` catches a stray `breakpoint()` if you want it enforced (`T20` catches `print`, but that fights the rule above — only for libraries).
- Hangs and segfaults: `python -X faulthandler` (or `faulthandler.dump_traceback_later(30)`) prints a stack instead of dying silently.

## Async

- Only for **I/O-bound concurrency** — many sockets or requests in flight. Not CPU work, not simple scripts.
- Never block the loop with sync I/O (`requests`, `psycopg2`): use the async client, or `asyncio.to_thread()` for blocking/CPU work.

## Testing

Not every codebase needs tests — a few standalone scripts don't; a large or shared one does, as
does non-trivial logic (parsers, math, branches) anywhere.

**Tests run anywhere**: no GPU, no cluster, no credentials, no big downloads — seconds on a bare
laptop. Tiny inputs; a 4×4 tensor proves the shape logic. Hardware-bound tests get
`@pytest.mark.gpu` and skip by default.

pytest, plain `assert`, `test_*.py`. `parametrize` over copy-paste. No fixtures until two tests
share setup. Mock at architectural boundaries only — never code you own; pass the dependency in.

## Never use (`ruff check --fix` rewrites most)

| Don't | Use instead |
|---|---|
| `.format()`, `%`, `"a" + str(b)` | f-strings |
| `os.path.join`, `os.listdir`, `glob.glob` | `pathlib.Path` |
| `List[int]`, `Optional[X]`, `Union[A, B]` | `list[int]`, `X \| None`, `A \| B` |
| `TypeVar` + `Generic[T]` (new code) | PEP 695 `def f[T](...)`, `class C[T]` |
| `setup.py`, `setup.cfg`, `requirements.txt` | `pyproject.toml` + `uv.lock` |
| `pip`, `virtualenv`, `poetry`, `conda` | `uv` |
| `black`, `flake8`, `isort` | `ruff format`, `ruff check` |
| `==` pins in `pyproject.toml` | `>=MAJOR.MINOR` + committed `uv.lock` |
| `range(len(xs))` | `enumerate(xs)` / `zip(a, b, strict=True)` |
| `except:` / `except Exception: pass` | specific exception, or `contextlib.suppress` |
| `type=bool`, paired `store_true`/`store_false` | `action=argparse.BooleanOptionalAction` |
| `pickle` for data | JSON / CSV / parquet |
| `dict` as an ad-hoc record | `@dataclass` |
| `datetime.utcnow()` | `datetime.now(timezone.utc)` |
| `typing.Text`, `six`, `# -*- coding: utf-8 -*-`, `class C(object)` | delete |
