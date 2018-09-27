from godot import exposed, export
from godot.bindings import *
from godot.globals import *

from subprocess import PIPE
import json

from godot.bindings import Dictionary

#Demonstrate Jupyter Dependancies are net
import jupyter_client
from jupyter_client import KernelManager
import zmq # ZeroMQ messaging protocol
import traitlets
import notebook

# Demonstrate all IPython Dependancies are met
import IPython # IPython (Interactive Python) is a command shell for interactive computing in multiple programming languages,
import pygments #Pygments is a syntax highlighting package written in Python.
import pexpect # Pexpect is a pure Python module for spawning child applications; controlling them; and responding to expected patterns in their output
import ptyprocess # Launch a subprocess in a pseudo terminal (pty), and interact with both the process and its pty.
import pickleshare # PickleShare - a small ‘shelve’ like datastore with concurrency support
import backcall # Specifications for callback functions passed in to an API
import prompt_toolkit # prompt_toolkit is a library for building powerful interactive command lines and terminal applications in Python.
import wcwidth # Python library that measures the width of unicode strings rendered to a terminal
import simplegeneric # The simplegeneric module lets you define simple single-dispatch generic functions, akin to Python’s built-in generic functions like len(), iter() and so on.

# Other Stuff
import psutil # psutil (python system and process utilities) is a cross-platform library for retrieving information on running processes and system utilization (CPU, memory, disks, network, sensors) in Python.
import termgraph # a python command-line tool which draws basic graphs in the terminal
import pprint

@exposed
class python(Control):
	# member variables here, example:
	command_test = export(str, default="'Jupter Kernel Test: Good!'")
	response = export(str)
	response2 = export(Dictionary)

	def _ready(self):
		"""
		Called every time the node is added to the scene.
		Initialization here.
		"""
		#self.execute_command(self.command_test)
		self.response=Array()
		self.response2=Dictionary()
		print("Python3-Godot Loaded")

	def execute_command(self, command):
		import time
		try:
				from queue import Empty  # Py 3
		except ImportError:
				from Queue import Empty  # Py 2

		km = KernelManager(kernel_name='python')
		km.start_kernel()
		print("Kernel Running: " + str(km.is_alive()))
		try:
			c = km.client()
			msg_id=c.execute(command)
			state='busy'
			data={}
			content_printer = pprint.PrettyPrinter(indent=4)
			content = {}
			while state!='idle' and c.is_alive():
				try:
					msg=c.get_iopub_msg(timeout=1)
					if not 'content' in msg:
						print("message has no content, moving on...")
						continue
					content = msg['content']
					for info in content:
						self.response2[info]=content[info]
					#content_printer.pprint(content)
				#	if 'data' in content:
				#		data=content['data']
					if 'execution_state' in content:
						state=content['execution_state']
				except Empty:
					pass
			#print(str(data))
		except KeyboardInterrupt:
			pass
		finally:
			km.shutdown_kernel()
			#print('Kernel Running Final : ' +  str(km.is_alive()))
			#response = json.dumps(data, ensure_ascii=True)
			#print(type(self.response2))
			#content_printer.pprint(self.response2)
			return self.response2
