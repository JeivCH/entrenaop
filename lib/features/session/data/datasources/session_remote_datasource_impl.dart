import 'package:entrenaop/core/errors/exceptions.dart';
import 'package:entrenaop/features/session/data/datasources/session_remote_datasource.dart';
import 'package:entrenaop/features/session/data/models/session_log_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SessionRemoteDataSourceImpl implements SessionRemoteDataSource {
  final SupabaseClient supabaseClient;

  SessionRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<void> createSessionLog(SessionLogModel log) async {
    try {
      await supabaseClient.from('session_logs').insert(log.toJson());
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<SessionLogModel>> getSessionLogsByUser(String userId) async {
    try {
      final response = await supabaseClient
          .from('session_logs')
          .select()
          .eq('user_id', userId)
          .order('completed_at', ascending: false);
      return (response as List)
          .map((j) => SessionLogModel.fromJson(j))
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
