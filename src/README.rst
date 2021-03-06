Protect Python Scripts By Pyarmor
=================================

Pyarmor is a command line tool used to obfuscate python scripts, bind
obfuscated scripts to fixed machine or expire obfuscated scripts. It
protects Python scripts by the following ways:

* Obfuscate code object to protect constants and literal strings.
* Obfuscate byte code of each code object in runtime.
* Clear f_locals of frame as soon as code object completed execution.
* Expired obfuscated scripts, or bind to fixed machine.

Look at what happened after ``foo.py`` is obfuscated by Pyarmor. Here
are the files list in the output path ``dist``::

    foo.py

    pytransform.py
    _pytransform.so, or _pytransform.dll in Windows, or _pytransform.dylib in MacOS

    pyshield.key
    pyshield.lic
    product.key
    license.lic

``dist/foo.py`` is obfuscated script, the content is::

    from pytransfrom import pyarmor_runtime
    pyarmor_runtime()

    __pyarmor__(__name__, __file__, b'\x06\x0f...', 1)

All the other extra files called ``Runtime Files``, which are required to run or
import obfuscated scripts. So long as runtime files are in any Python path,
obfuscated script ``dist/foo.py`` can be used as normal Python script.

**The original python scripts can be replaced with obfuscated scripts seamlessly.**

For details to visit `protect-python-scripts-by-pyarmor.md <https://github.com/dashingsoft/pyarmor/blob/master/docs/protect-python-scripts-by-pyarmor.md>`_

Support Platforms
-----------------

* Python 2.5, 2.6, 2.7 and Python3
* win32, win_amd64, linux_i386, linux_x86_64, macosx_x86_64
* Embedded Platform: Raspberry Pi, Banana Pi, TS-4600 / TS-7600

Quick Start
-----------

Install::

    pip install pyarmor

Obfuscate scripts::

    python pyarmor.py obfuscate --src=examples/simple --entry=queens.py

Run obfuscated scripts::

    cd dist
    python queens.py

Generate an expired license and run obfuscated scripts with new license::

    python pyarmor.py licenses --expired 2018-12-31 Customer-Jondy
    cp licenses/Customer-Jondy/license.lic dist/

    cd dist/
    python queens.py

There is a webui used to obfuscate script in gui mode. Start it::

    pyarmor-webui

Note that the webui doesn't include all the features of Pyarmor, it
can help you to understand Pyarmor quickly.

More Resources
--------------

- `Website <http://pyarmor.dashingsoft.com>`_
  `中文网站 <http://pyarmor.dashingsoft.com/index-zh.html>`_
- `Examples <https://github.com/dashingsoft/pyarmor/blob/master/src/examples>`_
- `WebUI Demo <http://pyarmor.dashingsoft.com/demo/index.html>`_
- `Source Code <https://github.com/dashingsoft/pyarmor>`_
- `User Guide <https://github.com/dashingsoft/pyarmor/blob/master/src/user-guide.md>`_
