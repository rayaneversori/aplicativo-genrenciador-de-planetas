class Planeta {
  int? id;
  String nome;
  double tamanho;
  double distancia;
  String? apelido;

  // Construtor principal
  Planeta({
    this.id,
    required this.nome,
    required this.tamanho,
    required this.distancia,
    this.apelido,
  });

  // Construtor vazio para inicialização padrão
  Planeta.vazio()
      : id = null,
        nome = '',
        tamanho = 0,
        distancia = 0,
        apelido = '';

  // Criar a partir de um Map
  factory Planeta.fromMap(Map<String, dynamic> map) {
    return Planeta(
      id: map['id'] as int?,
      nome: map['nome'] as String,
      tamanho: (map['tamanho'] as num).toDouble(),
      distancia: (map['distancia'] as num).toDouble(),
      apelido: map['apelido'] as String?,
    );
  }

  // Converter para Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'tamanho': tamanho,
      'distancia': distancia,
      'apelido': apelido,
    };
  }

  // Método para exibição amigável do planeta
  @override
  String toString() {
    return 'Planeta(id: $id, nome: $nome, tamanho: ${tamanho.toStringAsFixed(2)} km, distancia: ${distancia.toStringAsFixed(2)} km, apelido: ${apelido ?? "N/A"})';
  }
}
