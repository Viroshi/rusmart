import 'ticket_model.dart';

class DailyReportModel {
  final String dateKey;
  final DateTime date;
  final List<TicketModel> tickets;

  const DailyReportModel({
    required this.dateKey,
    required this.date,
    required this.tickets,
  });

  int get totalTickets {
    return tickets.length;
  }

  int get paidTickets {
    return tickets.where((ticket) => ticket.status == 'paid').length;
  }

  int get validatedTickets {
    return tickets.where((ticket) => ticket.status == 'validated').length;
  }

  int get expiredTickets {
    return tickets.where((ticket) => ticket.status == 'expired').length;
  }

  double get totalRevenue {
    return tickets.fold<double>(
      0,
      (total, ticket) => total + ticket.price,
    );
  }

  double get validatedRevenue {
    return tickets
        .where((ticket) => ticket.status == 'validated')
        .fold<double>(
          0,
          (total, ticket) => total + ticket.price,
        );
  }

  double get pendingRevenue {
    return tickets
        .where((ticket) => ticket.status == 'paid')
        .fold<double>(
          0,
          (total, ticket) => total + ticket.price,
        );
  }

  double get validationRate {
    if (totalTickets == 0) {
      return 0;
    }

    return validatedTickets / totalTickets;
  }

  List<TicketModel> get latestTickets {
    final orderedTickets = [...tickets];

    orderedTickets.sort(
      (a, b) => b.createdAt.compareTo(a.createdAt),
    );

    return orderedTickets.take(5).toList();
  }
}