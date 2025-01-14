import os
import sys
import shutil
from pathlib import Path
from typing import Any, List, Optional, Union, Dict

from deps.typing import (
    InstallMethod,
    InstallablesSpec,
    Installable,
    ParamInstallablesSpec,
    RequirementsSpec,
    TPathLike
)


def is_exec(path: Union[TPathLike, List[TPathLike]]) -> bool:
    """Check if a path is an executable.

    If a list is given, the elements of the list will be taken as aliases.
    """
    executable = False
    if isinstance(path, list):
        for p in path:
            executable = executable or bool(shutil.which(p, mode=os.X_OK))
    else:
        executable = bool(shutil.which(path, mode=os.X_OK))

    return executable


def assert_requirements(requirements: RequirementsSpec) -> None:
    for r in requirements['required']:
        if not is_exec(r):
            raise Exception(f"Required executable '{r}' not found")

    for r in requirements['optional']:
        if not is_exec(r):
            print(f"Optional executable '{r}' not found")


def assert_paths(paths: List[TPathLike], base_path: Optional[TPathLike] = None) -> None:
    for p in paths:
        if base_path:
            p = Path(base_path) / p

        Path(p).mkdir(parents=True, exist_ok=True)


def filter_by_installer(
    installables: Dict[str, Installable],
    installer: str
) -> Dict[str, Installable]:

    filtered_installables: Dict[str, Installable] = {}
    for inst_name, inst_val in installables.items():
        if inst_val['install_info']['method'] == installer:
            filtered_installables.update({inst_name: inst_val})

    return filtered_installables


def lookup_by_installer(
    installables: Dict[str, Installable]
) -> Dict[InstallMethod, Dict[str, Installable]]:

    lookup_table = {}
    for inst_name, inst_val in installables.items():
        inst_method = inst_val['install_info']['method']
        if inst_method not in lookup_table:
            lookup_table[inst_method] = {inst_name: inst_val}
        else:
            lookup_table[inst_method].update({inst_name: inst_val})

    return lookup_table


def replace_vars(value: Any):
    vars_table = {
        "{$HOME}": os.path.expanduser("~"),
    }

    if isinstance(value, str):
        for var, replacement in vars_table.items():
            value = value.replace(var, replacement)
    return value


def resolve_parameters(data: ParamInstallablesSpec) -> InstallablesSpec:
    data = data.copy()

    platform_dict = {
        'linux': 'linux',
        'win32': 'windows',
        'darwin': 'mac',
    }
    platform = platform_dict[sys.platform]

    def _resolve(_data):

        if isinstance(_data, list):
            for i, value in enumerate(_data):
                _data[i] = _resolve(value)

        elif isinstance(_data, dict):
            if 'with_params' in _data:
                _data = _data['with_params'].replace(
                    '{os_param}',
                    _data['os_param'][platform]
                )

            else:
                for key, value in _data.items():
                    _data[key] = _resolve(value)

        return replace_vars(_data)

    return _resolve(data)  # type: ignore


def box_print(text: str, box_char: str = '-'):
    term_width = shutil.get_terminal_size().columns
    print(box_char * term_width)
    print(text)
    print(box_char * term_width)
