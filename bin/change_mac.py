import sys
import subprocess

print("Number of arguments:", len(sys.argv), "arguments")
the_args = sys.argv
print("the_args", the_args)
mac_address = the_args[1]
print("mac_address",mac_address)

subprocess.run(["ip", "link", "set", "dev", "wlo1", "down"])
subprocess.run(["ip", "link", "set", "dev", "wlo1", "address", mac_address])
subprocess.run(["ip", "link", "set", "dev", "wlo1", "up"])
