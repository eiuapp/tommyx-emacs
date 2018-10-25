
class Server(object):

	def __init__(self, protocol, handler):
		self.protocol = protocol
		self.handler = handler

	def listen(self, args):
		raise NotImplementedError()

class STDIOServer(Server):

	def __init__(self, protocol, handler):
		Server.__init__(self, protocol, handler)

	def listen(self, args = None):
		while True:
			request = str(input())
			data = self.protocol.decode(request)
			response = self.handler(data)
			message = self.protocol.encode(response)
			print(message)
