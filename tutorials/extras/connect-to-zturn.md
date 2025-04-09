# Connecting to the Z-turn
- IPv4: `128.91.42.95`
- Z-turn login: `casbuser`
- Password: `casbdontfailmenow`

### Using SSH
```bash
ssh casbuser@<ip-address>
```

### Using USB
- Connect `USB_UART` port on Z-turn to computer
- Find the serial port and look for somthing like `/dev/tty.usbserial-xxxx`
```bash
ls /dev/tty.*
```
- Start a screen session on the Z-turn. Need to specify baud rate (bits transfered per second) of 115200. Z-turns serial port baud rate is pre-specified to 11520, and computer needs to match in order for the data transfer to be synchornized
```bash
screen /dev/tty.usbserial-xxxx 115200
```
- If this doesn't work (becuase the baud rate wasn't specified), find the screen sesson
```bash
screen -ls
```
Then get the id numebr and kill it
```bash
screen -X -S <id> quit
```


