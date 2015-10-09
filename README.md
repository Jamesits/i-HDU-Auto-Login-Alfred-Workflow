# i-HDU Auto Login

This is an Alfred workflow which enables you to login to i-HDU with the command `hdu`. 

## Usage

1. Edit `~/.i-hdu` in the following format: 
	```
	Username (8-digit number)
	Password
	```
	
2. Use command `hdu` to login. 

## Explanation

This script will do the following things:

1. Power on your Wi-Fi Adapter
2. Connect to i-HDU (If you haven't connected to it before, it may request administrator password for multiple times. )
3. Login automatically using credential in `~/.i-hdu`

## Dependencies

 * Alfred 2 and Powerpack
 * Bash
 * **Python 3**

## Author

 * [James Swineson](https://swineson.me)
 
## Thanks

 * [Alfred](https://www.alfredapp.com/)
 * [XGHeaven/i-hdu-wifi-login](https://github.com/XGHeaven/i-hdu-wifi-login)
