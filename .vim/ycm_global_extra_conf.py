import os

def walk_parent_directories(path):
    """Iterate over the parent directories of ``path``.
    Args:
        path (str): A path to a directory.
    Yields:
        The input path and all of its parent directories, in ascending order.
    """
    path = os.path.abspath(path)
    while True:
        parent = os.path.dirname(path)
        yield path
        if parent == path:
            # reached root
            break
        path = parent


def find_python(path):
    for path in walk_parent_directories(path):
        venv_path = os.path.join(path, '.venv', 'bin', 'python')
        if os.path.exists(venv_path):
            return venv_path, path
    return None, None


def Settings(**kwargs):
  client_data = kwargs['client_data']
  if kwargs['language'] == 'python':
      options = {}

      interpreter_path, _ = find_python(kwargs['filename'])
      if interpreter_path is not None:
          options['interpreter_path'] = interpreter_path

      return options

  return {}
