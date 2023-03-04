const _emailRegex = r"(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)";
const _phoneNumberRegex = r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$';

final RegExp emailRegExp = RegExp(_emailRegex);

final RegExp phoneRegExp = RegExp(_phoneNumberRegex);
