import 'package:entrenaop/features/routines/domain/entities/routine_entity.dart';
import 'package:entrenaop/features/routines/domain/repositories/routine_repository.dart';

class GetPublicRoutinesUseCase {
  final RoutineRepository repository;
  GetPublicRoutinesUseCase(this.repository);

  Future<List<RoutineEntity>> call() async {
    return await repository.getPublicRoutines();
  }
}
