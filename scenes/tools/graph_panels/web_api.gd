extends MarginContainer

func _ready():
	pass # Replace with function body.

var api = {
   "swagger": "2.0",
   "info": {
      "title": "Jupyter Notebook API",
      "description": "Notebook API",
      "version": "5",
      "contact": {
         "name": "Jupyter Project",
         "url": "https://jupyter.org"
      }
   },
   "basePath": "/",
   "produces": [
      "application/json"
   ],
   "consumes": [
      "application/json"
   ],
   "parameters": {
      "kernel": {
         "name": "kernel_id",
         "required": true,
         "in": "path",
         "description": "kernel uuid",
         "type": "string",
         "format": "uuid"
      },
      "session": {
         "name": "session",
         "required": true,
         "in": "path",
         "description": "session uuid",
         "type": "string",
         "format": "uuid"
      },
      "path": {
         "name": "path",
         "required": true,
         "in": "path",
         "description": "file path",
         "type": "string"
      },
      "checkpoint_id": {
         "name": "checkpoint_id",
         "required": true,
         "in": "path",
         "description": "Checkpoint id for a file",
         "type": "string"
      },
      "section_name": {
         "name": "section_name",
         "required": true,
         "in": "path",
         "description": "Name of config section",
         "type": "string"
      },
      "terminal_id": {
         "name": "terminal_id",
         "required": true,
         "in": "path",
         "description": "ID of terminal session",
         "type": "string"
      }
   },
   "paths": {
      "/api/contents/{path}": {
         "parameters": [
            {
               "$ref": "#/parameters/path"
            }
         ],
         "get": {
            "summary": "Get contents of file or directory",
            "description": "A client can optionally specify a type and/or format argument via URL parameter. When given, the Contents service shall return a model in the requested type and/or format. If the request cannot be satisfied, e.g. type=text is requested, but the file is binary, then the request shall fail with 400 and have a JSON response containing a 'reason' field, with the value 'bad format' or 'bad type', depending on what was requested.",
            "tags": [
               "contents"
            ],
            "parameters": [
               {
                  "name": "type",
                  "in": "query",
                  "description": "File type ('file', 'directory')",
                  "type": "string",
                  "enum": [
                     "file",
                     "directory"
                  ]
               },
               {
                  "name": "format",
                  "in": "query",
                  "description": "How file content should be returned ('text', 'base64')",
                  "type": "string",
                  "enum": [
                     "text",
                     "base64"
                  ]
               },
               {
                  "name": "content",
                  "in": "query",
                  "description": "Return content (0 for no content, 1 for return content)",
                  "type": "integer"
               }
            ],
            "responses": {
               "200": {
                  "description": "Contents of file or directory",
                  "headers": {
                     "Last-Modified": {
                        "description": "Last modified date for file",
                        "type": "string",
                        "format": "dateTime"
                     }
                  },
                  "schema": {
                     "$ref": "#/definitions/Contents"
                  }
               },
               "400": {
                  "description": "Bad request",
                  "schema": {
                     "type": "object",
                     "properties": {
                        "error": {
                           "type": "string",
                           "description": "Error condition"
                        },
                        "reason": {
                           "type": "string",
                           "description": "Explanation of error reason"
                        }
                     }
                  }
               },
               "404": {
                  "description": "No item found"
               },
               "500": {
                  "description": "Model key error"
               }
            }
         },
         "post": {
            "summary": "Create a new file in the specified path",
            "description": "A POST to /api/contents/path creates a New untitled, empty file or directory. A POST to /api/contents/path with body {'copy_from': '/path/to/OtherNotebook.ipynb'} creates a new copy of OtherNotebook in path.",
            "tags": [
               "contents"
            ],
            "parameters": [
               {
                  "name": "model",
                  "in": "body",
                  "description": "Path of file to copy",
                  "schema": {
                     "type": "object",
                     "properties": {
                        "copy_from": {
                           "type": "string"
                        },
                        "ext": {
                           "type": "string"
                        },
                        "type": {
                           "type": "string"
                        }
                     }
                  }
               }
            ],
            "responses": {
               "201": {
                  "description": "File created",
                  "headers": {
                     "Location": {
                        "description": "URL for the new file",
                        "type": "string",
                        "format": "url"
                     }
                  },
                  "schema": {
                     "$ref": "#/definitions/Contents"
                  }
               },
               "400": {
                  "description": "Bad request",
                  "schema": {
                     "type": "object",
                     "properties": {
                        "error": {
                           "type": "string",
                           "description": "Error condition"
                        },
                        "reason": {
                           "type": "string",
                           "description": "Explanation of error reason"
                        }
                     }
                  }
               },
               "404": {
                  "description": "No item found"
               }
            }
         },
         "patch": {
            "summary": "Rename a file or directory without re-uploading content",
            "tags": [
               "contents"
            ],
            "parameters": [
               {
                  "name": "path",
                  "in": "body",
                  "required": true,
                  "description": "New path for file or directory.",
                  "schema": {
                     "type": "object",
                     "properties": {
                        "path": {
                           "type": "string",
                           "format": "path",
                           "description": "New path for file or directory"
                        }
                     }
                  }
               }
            ],
            "responses": {
               "200": {
                  "description": "Path updated",
                  "headers": {
                     "Location": {
                        "description": "Updated URL for the file or directory",
                        "type": "string",
                        "format": "url"
                     }
                  },
                  "schema": {
                     "$ref": "#/definitions/Contents"
                  }
               },
               "400": {
                  "description": "No data provided",
                  "schema": {
                     "type": "object",
                     "properties": {
                        "error": {
                           "type": "string",
                           "description": "Error condition"
                        },
                        "reason": {
                           "type": "string",
                           "description": "Explanation of error reason"
                        }
                     }
                  }
               }
            }
         },
         "put": {
            "summary": "Save or upload file.",
            "description": "Saves the file in the location specified by name and path.  PUT is very similar to POST, but the requester specifies the name, whereas with POST, the server picks the name.",
            "tags": [
               "contents"
            ],
            "parameters": [
               {
                  "name": "model",
                  "in": "body",
                  "description": "New path for file or directory",
                  "schema": {
                     "type": "object",
                     "properties": {
                        "name": {
                           "type": "string",
                           "description": "The new filename if changed"
                        },
                        "path": {
                           "type": "string",
                           "description": "New path for file or directory"
                        },
                        "type": {
                           "type": "string",
                           "description": "Path dtype ('notebook', 'file', 'directory')"
                        },
                        "format": {
                           "type": "string",
                           "description": "File format ('json', 'text', 'base64')"
                        },
                        "content": {
                           "type": "string",
                           "description": "The actual body of the document excluding directory type"
                        }
                     }
                  }
               }
            ],
            "responses": {
               "200": {
                  "description": "File saved",
                  "headers": {
                     "Location": {
                        "description": "Updated URL for the file or directory",
                        "type": "string",
                        "format": "url"
                     }
                  },
                  "schema": {
                     "$ref": "#/definitions/Contents"
                  }
               },
               "201": {
                  "description": "Path created",
                  "headers": {
                     "Location": {
                        "description": "URL for the file or directory",
                        "type": "string",
                        "format": "url"
                     }
                  },
                  "schema": {
                     "$ref": "#/definitions/Contents"
                  }
               },
               "400": {
                  "description": "No data provided",
                  "schema": {
                     "type": "object",
                     "properties": {
                        "error": {
                           "type": "string",
                           "description": "Error condition"
                        },
                        "reason": {
                           "type": "string",
                           "description": "Explanation of error reason"
                        }
                     }
                  }
               }
            }
         },
         "delete": {
            "summary": "Delete a file in the given path",
            "tags": [
               "contents"
            ],
            "responses": {
               "204": {
                  "description": "File deleted",
                  "headers": {
                     "Location": {
                        "description": "URL for the removed file",
                        "type": "string",
                        "format": "url"
                     }
                  }
               }
            }
         }
      },
      "/api/contents/{path}/checkpoints": {
         "parameters": [
            {
               "$ref": "#/parameters/path"
            }
         ],
         "get": {
            "summary": "Get a list of checkpoints for a file",
            "description": "List checkpoints for a given file. There will typically be zero or one results.",
            "tags": [
               "contents"
            ],
            "responses": {
               "200": {
                  "description": "List of checkpoints for a file",
                  "schema": {
                     "type": "array",
                     "items": {
                        "$ref": "#/definitions/Checkpoints"
                     }
                  }
               },
               "400": {
                  "description": "Bad request",
                  "schema": {
                     "type": "object",
                     "properties": {
                        "error": {
                           "type": "string",
                           "description": "Error condition"
                        },
                        "reason": {
                           "type": "string",
                           "description": "Explanation of error reason"
                        }
                     }
                  }
               },
               "404": {
                  "description": "No item found"
               },
               "500": {
                  "description": "Model key error"
               }
            }
         },
         "post": {
            "summary": "Create a new checkpoint for a file",
            "description": "Create a new checkpoint with the current state of a file. With the default FileContentsManager, only one checkpoint is supported, so creating new checkpoints clobbers existing ones.",
            "tags": [
               "contents"
            ],
            "responses": {
               "201": {
                  "description": "Checkpoint created",
                  "headers": {
                     "Location": {
                        "description": "URL for the checkpoint",
                        "type": "string",
                        "format": "url"
                     }
                  },
                  "schema": {
                     "$ref": "#/definitions/Checkpoints"
                  }
               },
               "400": {
                  "description": "Bad request",
                  "schema": {
                     "type": "object",
                     "properties": {
                        "error": {
                           "type": "string",
                           "description": "Error condition"
                        },
                        "reason": {
                           "type": "string",
                           "description": "Explanation of error reason"
                        }
                     }
                  }
               },
               "404": {
                  "description": "No item found"
               }
            }
         }
      },
      "/api/contents/{path}/checkpoints/{checkpoint_id}": {
         "post": {
            "summary": "Restore a file to a particular checkpointed state",
            "parameters": [
               {
                  "$ref": "#/parameters/path"
               },
               {
                  "$ref": "#/parameters/checkpoint_id"
               }
            ],
            "tags": [
               "contents"
            ],
            "responses": {
               "204": {
                  "description": "Checkpoint restored"
               },
               "400": {
                  "description": "Bad request",
                  "schema": {
                     "type": "object",
                     "properties": {
                        "error": {
                           "type": "string",
                           "description": "Error condition"
                        },
                        "reason": {
                           "type": "string",
                           "description": "Explanation of error reason"
                        }
                     }
                  }
               }
            }
         },
         "delete": {
            "summary": "Delete a checkpoint",
            "parameters": [
               {
                  "$ref": "#/parameters/path"
               },
               {
                  "$ref": "#/parameters/checkpoint_id"
               }
            ],
            "tags": [
               "contents"
            ],
            "responses": {
               "204": {
                  "description": "Checkpoint deleted"
               }
            }
         }
      },
      "/api/sessions/{session}": {
         "parameters": [
            {
               "$ref": "#/parameters/session"
            }
         ],
         "get": {
            "summary": "Get session",
            "tags": [
               "sessions"
            ],
            "responses": {
               "200": {
                  "description": "Session",
                  "schema": {
                     "$ref": "#/definitions/Session"
                  }
               }
            }
         },
         "patch": {
            "summary": "This can be used to rename the session.",
            "tags": [
               "sessions"
            ],
            "parameters": [
               {
                  "name": "model",
                  "in": "body",
                  "required": true,
                  "schema": {
                     "$ref": "#/definitions/Session"
                  }
               }
            ],
            "responses": {
               "200": {
                  "description": "Session",
                  "schema": {
                     "$ref": "#/definitions/Session"
                  }
               },
               "400": {
                  "description": "No data provided"
               }
            }
         },
         "delete": {
            "summary": "Delete a session",
            "tags": [
               "sessions"
            ],
            "responses": {
               "204": {
                  "description": "Session (and kernel) were deleted"
               },
               "410": {
                  "description": "Kernel was deleted before the session, and the session was *not* deleted (TODO - check to make sure session wasn't deleted)"
               }
            }
         }
      },
      "/api/sessions": {
         "get": {
            "summary": "List available sessions",
            "tags": [
               "sessions"
            ],
            "responses": {
               "200": {
                  "description": "List of current sessions",
                  "schema": {
                     "type": "array",
                     "items": {
                        "$ref": "#/definitions/Session"
                     }
                  }
               }
            }
         },
         "post": {
            "summary": "Create a new session, or return an existing session if a session of the same name already exists",
            "tags": [
               "sessions"
            ],
            "parameters": [
               {
                  "name": "session",
                  "in": "body",
                  "schema": {
                     "$ref": "#/definitions/Session"
                  }
               }
            ],
            "responses": {
               "201": {
                  "description": "Session created or returned",
                  "schema": {
                     "$ref": "#/definitions/Session"
                  },
                  "headers": {
                     "Location": {
                        "description": "URL for session commands",
                        "type": "string",
                        "format": "url"
                     }
                  }
               },
               "501": {
                  "description": "Session not available",
                  "schema": {
                     "type": "object",
                     "description": "error message",
                     "properties": {
                        "message": {
                           "type": "string"
                        },
                        "short_message": {
                           "type": "string"
                        }
                     }
                  }
               }
            }
         }
      },
      "/api/kernels": {
         "get": {
            "summary": "List the JSON data for all kernels that are currently running",
            "tags": [
               "kernels"
            ],
            "responses": {
               "200": {
                  "description": "List of currently-running kernel uuids",
                  "schema": {
                     "type": "array",
                     "items": {
                        "$ref": "#/definitions/Kernel"
                     }
                  }
               }
            }
         },
         "post": {
            "summary": "Start a kernel and return the uuid",
            "tags": [
               "kernels"
            ],
            "parameters": [
               {
                  "name": "name",
                  "in": "body",
                  "description": "Kernel spec name (defaults to default kernel spec for server)",
                  "schema": {
                     "type": "object",
                     "properties": {
                        "name": {
                           "type": "string"
                        }
                     }
                  }
               }
            ],
            "responses": {
               "201": {
                  "description": "Kernel started",
                  "schema": {
                     "$ref": "#/definitions/Kernel"
                  },
                  "headers": {
                     "Location": {
                        "description": "Model for started kernel",
                        "type": "string",
                        "format": "url"
                     }
                  }
               }
            }
         }
      },
      "/api/kernels/{kernel_id}": {
         "parameters": [
            {
               "$ref": "#/parameters/kernel"
            }
         ],
         "get": {
            "summary": "Get kernel information",
            "tags": [
               "kernels"
            ],
            "responses": {
               "200": {
                  "description": "Kernel information",
                  "schema": {
                     "$ref": "#/definitions/Kernel"
                  }
               }
            }
         },
         "delete": {
            "summary": "Kill a kernel and delete the kernel id",
            "tags": [
               "kernels"
            ],
            "responses": {
               "204": {
                  "description": "Kernel deleted"
               }
            }
         }
      },
      "/api/kernels/{kernel_id}/interrupt": {
         "parameters": [
            {
               "$ref": "#/parameters/kernel"
            }
         ],
         "post": {
            "summary": "Interrupt a kernel",
            "tags": [
               "kernels"
            ],
            "responses": {
               "204": {
                  "description": "Kernel interrupted"
               }
            }
         }
      },
      "/api/kernels/{kernel_id}/restart": {
         "parameters": [
            {
               "$ref": "#/parameters/kernel"
            }
         ],
         "post": {
            "summary": "Restart a kernel",
            "tags": [
               "kernels"
            ],
            "responses": {
               "200": {
                  "description": "Kernel interrupted",
                  "headers": {
                     "Location": {
                        "description": "URL for kernel commands",
                        "type": "string",
                        "format": "url"
                     }
                  },
                  "schema": {
                     "$ref": "#/definitions/Kernel"
                  }
               }
            }
         }
      },
      "/api/kernelspecs": {
         "get": {
            "summary": "Get kernel specs",
            "tags": [
               "kernelspecs"
            ],
            "responses": {
               "200": {
                  "description": "Kernel specs",
                  "schema": {
                     "type": "object",
                     "properties": {
                        "default": {
                           "type": "string",
                           "description": "Default kernel name"
                        },
                        "kernelspecs": {
                           "type": "object",
                           "additionalProperties": {
                              "$ref": "#/definitions/KernelSpec"
                           }
                        }
                     }
                  }
               }
            }
         }
      },
      "/api/config/{section_name}": {
         "get": {
            "summary": "Get a configuration section by name",
            "parameters": [
               {
                  "$ref": "#/parameters/section_name"
               }
            ],
            "tags": [
               "config"
            ],
            "responses": {
               "200": {
                  "description": "Configuration object",
                  "schema": {
                     "type": "object"
                  }
               }
            }
         },
         "patch": {
            "summary": "Update a configuration section by name",
            "tags": [
               "config"
            ],
            "parameters": [
               {
                  "$ref": "#/parameters/section_name"
               },
               {
                  "name": "configuration",
                  "in": "body",
                  "schema": {
                     "type": "object"
                  }
               }
            ],
            "responses": {
               "200": {
                  "description": "Configuration object",
                  "schema": {
                     "type": "object"
                  }
               }
            }
         }
      },
      "/api/terminals": {
         "get": {
            "summary": "Get available terminals",
            "tags": [
               "terminals"
            ],
            "responses": {
               "200": {
                  "description": "A list of all available terminal ids.",
                  "schema": {
                     "type": "array",
                     "items": {
                        "$ref": "#/definitions/Terminal_ID"
                     }
                  }
               },
               "403": {
                  "description": "Forbidden to access"
               },
               "404": {
                  "description": "Not found"
               }
            }
         },
         "post": {
            "summary": "Create a new terminal",
            "tags": [
               "terminals"
            ],
            "responses": {
               "200": {
                  "description": "Succesfully created a new terminal",
                  "schema": {
                     "$ref": "#/definitions/Terminal_ID"
                  }
               },
               "403": {
                  "description": "Forbidden to access"
               },
               "404": {
                  "description": "Not found"
               }
            }
         }
      },
      "/api/terminals/{terminal_id}": {
         "get": {
            "summary": "Get a terminal session corresponding to an id.",
            "tags": [
               "terminals"
            ],
            "parameters": [
               {
                  "$ref": "#/parameters/terminal_id"
               }
            ],
            "responses": {
               "200": {
                  "description": "Terminal session with given id",
                  "schema": {
                     "$ref": "#/definitions/Terminal_ID"
                  }
               },
               "403": {
                  "description": "Forbidden to access"
               },
               "404": {
                  "description": "Not found"
               }
            }
         },
         "delete": {
            "summary": "Delete a terminal session corresponding to an id.",
            "tags": [
               "terminals"
            ],
            "parameters": [
               {
                  "$ref": "#/parameters/terminal_id"
               }
            ],
            "responses": {
               "204": {
                  "description": "Succesfully deleted terminal session"
               },
               "403": {
                  "description": "Forbidden to access"
               },
               "404": {
                  "description": "Not found"
               }
            }
         }
      },
      "/api/status": {
         "get": {
            "summary": "Get the current status/activity of the server.",
            "tags": [
               "status"
            ],
            "responses": {
               "200": {
                  "description": "The current status of the server",
                  "schema": {
                     "$ref": "#/definitions/APIStatus"
                  }
               }
            }
         }
      },
      "/api/spec.yaml": {
         "get": {
            "summary": "Get the current spec for the notebook server's APIs.",
            "tags": [
               "api-spec"
            ],
            "produces": [
               "text/x-yaml"
            ],
            "responses": {
               "200": {
                  "description": "The current spec for the notebook server's APIs.",
                  "schema": {
                     "type": "file"
                  }
               }
            }
         }
      }
   },
   "definitions": {
      "APIStatus": {
         "description": "Notebook server API status.\nAdded in notebook 5.0.\n",
         "properties": {
            "started": {
               "type": "string",
               "description": "ISO8601 timestamp indicating when the notebook server started.\n"
            },
            "last_activity": {
               "type": "string",
               "description": "ISO8601 timestamp indicating the last activity on the server,\neither on the REST API or kernel activity.\n"
            },
            "connections": {
               "type": "number",
               "description": "The total number of currently open connections to kernels.\n"
            },
            "kernels": {
               "type": "number",
               "description": "The total number of running kernels.\n"
            }
         }
      },
      "KernelSpec": {
         "description": "Kernel spec (contents of kernel.json)",
         "properties": {
            "name": {
               "type": "string",
               "description": "Unique name for kernel"
            },
            "KernelSpecFile": {
               "$ref": "#/definitions/KernelSpecFile"
            },
            "resources": {
               "type": "object",
               "properties": {
                  "kernel.js": {
                     "type": "string",
                     "format": "filename",
                     "description": "path for kernel.js file"
                  },
                  "kernel.css": {
                     "type": "string",
                     "format": "filename",
                     "description": "path for kernel.css file"
                  },
                  "logo-*": {
                     "type": "string",
                     "format": "filename",
                     "description": "path for logo file.  Logo filenames are of the form `logo-widthxheight`"
                  }
               }
            }
         }
      },
      "KernelSpecFile": {
         "description": "Kernel spec json file",
         "required": [
            "argv",
            "display_name",
            "language"
         ],
         "properties": {
            "language": {
               "type": "string",
               "description": "The programming language which this kernel runs. This will be stored in notebook metadata."
            },
            "argv": {
               "type": "array",
               "description": "A list of command line arguments used to start the kernel. The text `{connection_file}` in any argument will be replaced with the path to the connection file.",
               "items": {
                  "type": "string"
               }
            },
            "display_name": {
               "type": "string",
               "description": "The kernel's name as it should be displayed in the UI. Unlike the kernel name used in the API, this can contain arbitrary unicode characters."
            },
            "codemirror_mode": {
               "type": "string",
               "description": "Codemirror mode.  Can be a string *or* an valid Codemirror mode object.  This defaults to the string from the `language` property."
            },
            "env": {
               "type": "object",
               "description": "A dictionary of environment variables to set for the kernel. These will be added to the current environment variables.",
               "additionalProperties": {
                  "type": "string"
               }
            },
            "help_links": {
               "type": "array",
               "description": "Help items to be displayed in the help menu in the notebook UI.",
               "items": {
                  "type": "object",
                  "required": [
                     "text",
                     "url"
                  ],
                  "properties": {
                     "text": {
                        "type": "string",
                        "description": "menu item link text"
                     },
                     "url": {
                        "type": "string",
                        "format": "URL",
                        "description": "menu item link url"
                     }
                  }
               }
            }
         }
      },
      "Kernel": {
         "description": "Kernel information",
         "required": [
            "id",
            "name"
         ],
         "properties": {
            "id": {
               "type": "string",
               "format": "uuid",
               "description": "uuid of kernel"
            },
            "name": {
               "type": "string",
               "description": "kernel spec name"
            },
            "last_activity": {
               "type": "string",
               "description": "ISO 8601 timestamp for the last-seen activity on this kernel.\nUse this in combination with execution_state == 'idle' to identify\nwhich kernels have been idle since a given time.\nTimestamps will be UTC, indicated 'Z' suffix.\nAdded in notebook server 5.0.\n"
            },
            "connections": {
               "type": "number",
               "description": "The number of active connections to this kernel.\n"
            },
            "execution_state": {
               "type": "string",
               "description": "Current execution state of the kernel (typically 'idle' or 'busy', but may be other values, such as 'starting').\nAdded in notebook server 5.0.\n"
            }
         }
      },
      "Session": {
         "description": "A session",
         "type": "object",
         "properties": {
            "id": {
               "type": "string",
               "format": "uuid"
            },
            "path": {
               "type": "string",
               "description": "path to the session"
            },
            "name": {
               "type": "string",
               "description": "name of the session"
            },
            "type": {
               "type": "string",
               "description": "session type"
            },
            "kernel": {
               "$ref": "#/definitions/Kernel"
            }
         }
      },
      "Contents": {
         "description": "A contents object.  The content and format keys may be null if content is not contained.  If type is 'file', then the mimetype will be null.",
         "type": "object",
         "required": [
            "type",
            "name",
            "path",
            "writable",
            "created",
            "last_modified",
            "mimetype",
            "format",
            "content"
         ],
         "properties": {
            "name": {
               "type": "string",
               "description": "Name of file or directory, equivalent to the last part of the path"
            },
            "path": {
               "type": "string",
               "description": "Full path for file or directory"
            },
            "type": {
               "type": "string",
               "description": "Type of content",
               "enum": [
                  "directory",
                  "file",
                  "notebook"
               ]
            },
            "writable": {
               "type": "boolean",
               "description": "indicates whether the requester has permission to edit the file"
            },
            "created": {
               "type": "string",
               "description": "Creation timestamp",
               "format": "dateTime"
            },
            "last_modified": {
               "type": "string",
               "description": "Last modified timestamp",
               "format": "dateTime"
            },
            "size": {
               "type": "integer",
               "description": "The size of the file or notebook in bytes. If no size is provided, defaults to null."
            },
            "mimetype": {
               "type": "string",
               "description": "The mimetype of a file.  If content is not null, and type is 'file', this will contain the mimetype of the file, otherwise this will be null."
            },
            "content": {
               "type": "string",
               "description": "The content, if requested (otherwise null).  Will be an array if type is 'directory'"
            },
            "format": {
               "type": "string",
               "description": "Format of content (one of null, 'text', 'base64', 'json')"
            }
         }
      },
      "Checkpoints": {
         "description": "A checkpoint object.",
         "type": "object",
         "required": [
            "id",
            "last_modified"
         ],
         "properties": {
            "id": {
               "type": "string",
               "description": "Unique id for the checkpoint."
            },
            "last_modified": {
               "type": "string",
               "description": "Last modified timestamp",
               "format": "dateTime"
            }
         }
      },
      "Terminal_ID": {
         "description": "A Terminal_ID object",
         "type": "object",
         "required": [
            "name"
         ],
         "properties": {
            "name": {
               "type": "string",
               "description": "name of terminal ID"
            }
         }
      }
   }
}