# Input hex strings
input_hex1 = "00112233445566778899aabbccddeeff22222222222222222222222222222222222222222222222222222"
input_hex2 = "000102030405060708090a0b0c0d0e0f1011121314151617111111111111111111111111"
# input_hex2 = "000102030405060708090a0b0c0d0e0f1011121314151617"

# Combine both hex strings
combined_hex = input_hex1 + input_hex2

# Split into 32-bit (8 hex characters) chunks
chunks = [combined_hex[i:i+8] for i in range(0, len(combined_hex), 8)]

# # Open a file to write the output
# with open("Data_Mem.txt", "w") as file:
#     for i, chunk in enumerate(chunks):
#         address = f"{i * 4:08x}"  # Address in 8-digit hex format
#         line = f"{address}_{chunk}"
#         file.write(line + "\n")  # Write each line to the file
#         print(line)  # Optionally print to the console

try:
    with open("Data_Mem.txt", "w") as file:
        for i, chunk in enumerate(chunks):
            address = f"{i * 4:08x}"  # Address in 8-digit hex format
            line = f"{address}_{chunk}"
            file.write(line + "\n")  # Write each line to the file
            print(line)  # Optionally print to the console
except IOError as e:
    print(f"Error opening or writing to file: {e}")
