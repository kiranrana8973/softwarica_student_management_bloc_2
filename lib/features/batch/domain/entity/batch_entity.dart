import 'package:equatable/equatable.dart';

class BatchEntity extends Equatable {
  final String? batchId;
  final String batchName;

  const BatchEntity({
    this.batchId,
    required this.batchName,
  });

// Create an empty constructor or Initial Constructor
  const BatchEntity.empty()
      : batchId = '_empty.batchId',
        batchName = '_empty.batchName';

  @override
  List<Object?> get props => [batchId, batchName];
}
