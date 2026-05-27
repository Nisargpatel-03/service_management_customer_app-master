import 'package:cloud_firestore/cloud_firestore.dart';

class ComplaintMessage {
  final String senderId, senderName, message, senderRole;
  final DateTime time;
  ComplaintMessage({
    required this.senderId, required this.senderName,
    required this.message, required this.senderRole, required this.time
  });

  Map<String, dynamic> toMap() => {
    'senderId': senderId,
    'senderName': senderName,
    'message': message,
    'senderRole': senderRole,
    'time': Timestamp.fromDate(time),
  };

  factory ComplaintMessage.fromMap(Map<String, dynamic> map) => ComplaintMessage(
    senderId: map['senderId'] ?? '',
    senderName: map['senderName'] ?? '',
    message: map['message'] ?? '',
    senderRole: map['senderRole'] ?? 'user',
    time: (map['time'] as Timestamp?)?.toDate() ?? DateTime.now(),
  );
}

class ComplaintModel {
  final String id, title, status, description, address, ticketNo, customerName;
  final DateTime date;
  final List<String> attachments;
  final List<ComplaintMessage> messages;
  final String? assignedTechnicianId;

  ComplaintModel({
    required this.id,
    required this.title,
    required this.status,
    required this.description,
    required this.address,
    required this.ticketNo,
    required this.customerName,
    required this.date,
    required this.attachments,
    required this.messages,
    this.assignedTechnicianId,
  });

  factory ComplaintModel.fromMap(Map<String, dynamic> map, String docId) {
    return ComplaintModel(
      id: docId,
      title: map['issue'] ?? map['title'] ?? 'No Title',
      status: map['status'] ?? 'Open',
      description: map['description'] ?? map['details'] ?? '',
      address: map['address'] ?? '',
      ticketNo: map['ticketNo'] ?? map['ticket_no'] ?? '',
      customerName: map['userName'] ?? map['customerName'] ?? 'User',
      date: (map['createdAt'] is Timestamp)
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      attachments: List<String>.from(map['attachments'] ?? []),
      messages: (map['messages'] as List?)
              ?.map((m) => ComplaintMessage.fromMap(Map<String, dynamic>.from(m)))
              .toList() ?? [],
      assignedTechnicianId: map['assignedTechnicianId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'status': status,
      'description': description,
      'address': address,
      'ticketNo': ticketNo,
      'date': date,
      'customerName': customerName,
      'assignedTechnicianId': assignedTechnicianId,
    };
  }
}
