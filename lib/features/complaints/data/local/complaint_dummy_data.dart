class ComplaintDummyData {
  static List<Map<String,dynamic>> allComplaints = [

    // ✅ Current Pending Complaint
    {
      "title": "Electricity Meter Issue",
      "status": "Pending",
      "date": "07 Feb 2026",
      "technician": "Not Assigned Yet",
      "technicianPhone": "",
      "eta": "ETA: 2 Working Days",
      "description": "Voltage is unstable and appliances are shutting down.",
    },

    // ✅ In Progress Complaint (Call Button Enabled)
    {
      "title": "Voltage Fluctuation",
      "status": "In Progress",
      "date": "05 Feb 2026",
      "technician": "Amit Patel",
      "technicianPhone": "9876543210",
      "eta": "ETA: Tomorrow Evening",
      "description": "Voltage is unstable and appliances are shutting down.",
    },

    // ✅ Completed Complaint (History Section)
    {
      "title": "Power Cut Issue Resolved",
      "status": "Completed",
      "date": "01 Feb 2026",
      "technician": "Rahul Sharma",
      "technicianPhone": "9998887776",
      "eta": "Completed ✅",
      "description": "Voltage is unstable and appliances are shutting down.",
    },
  ];
}