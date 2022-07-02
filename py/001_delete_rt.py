import requests

jwt = input("Enter JWT here:\n> ")
resource_id = input("Enter resource ID here:\n> ")
sinopia_platform = input("Delete from Development, Stage, or Production?\n[1] Development\n[2] Stage\n[3] Production\n> ")
if sinopia_platform == "1":
	sinopia_platform = "development."
elif sinopia_platform == "2":
	sinopia_platform = "stage."
elif sinopia_platform == "3":
	sinopia_platform = ""
else:
	print("Platform not recognized.")
	quit()

headers = {"Authorization": f"Bearer {jwt}", "Content-Type": "application/json"}

delete_from_sinopia = requests.delete(f"https://api.{sinopia_platform}sinopia.io/resource/{resource_id}", headers = headers)

print(delete_from_sinopia.status_code)

# 204 = deleted
# 401 = Unauthorized
# 404 = Not found
