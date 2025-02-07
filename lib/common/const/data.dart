// ignore_for_file: constant_identifier_names

import 'dart:io';

const ACCESS_TOKEN_KEY = 'ACCESS_TOKEN';
const REFRESH_TOKEN_KEY = 'REFRESH_TOKEN';

// local host for android emulator
const emulatorIP = '10.0.2.2:3000';
// local host for ios simulator
const simulatorIP = '127.0.0.1:3000';

final String ip = Platform.isIOS ? simulatorIP : emulatorIP;
