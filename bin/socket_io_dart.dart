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

    client.on('leaveRoom', (room) {
      client.leave(room, (_) {
        // print('Client ${client.id} left room: $room');
        // Optionally notify others in the room
        io.to(room).emit('user_left', {'clientId': client.id, 'room': room});
      });
    });
  });

  io.listen(3000);
}
