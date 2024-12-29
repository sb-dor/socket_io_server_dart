import 'package:socket_io/socket_io.dart';

void main(List<String> arguments) async {
  Server io = Server();
  io.on('connection', (client) {
    client.on('echo', (data) {
      client.emit('echo', data);
    });

    client.on('broadcast', (data) {
      io.emit('broadcast', data);
    });

    client.on('joinRoom', (data) {
      client.join(data.toString());
      client.emit('join', data);
    });

    client.on('room', (data) {
      io.to(data['room']).emit('room', data['message']);
    });

    client.on('leaveRoom', (data) {
      client.leave(data, (_) {
        // Optionally notify others in the room
        io.to(data).emit('room', {"leave": "user_left"}); // {"leave" : "user_left"} just a message
      });
    });
  });

  io.listen(3000);
}
