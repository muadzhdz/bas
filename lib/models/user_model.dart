class UserModel {
  final String idUsers;
  final int userid; // NPM mahasiswa
  final String nama;
  final String loginName;
  final String pass;
  final String passSha1;
  final int roleid;
  final int status; // 1 = aktif, 0 = disable
  final int aktif; // 1 = aktif, 0 = disable
  final int babsen; // 1 = aktif, 0 = disable
  final int bperwalian; // 1 = aktif, 0 = disable (KRS)
  final int bujian; // 1 = aktif, 0 = disable

  UserModel({
    required this.idUsers,
    required this.userid,
    required this.nama,
    required this.loginName,
    required this.pass,
    required this.passSha1,
    required this.roleid,
    required this.status,
    required this.aktif,
    required this.babsen,
    required this.bperwalian,
    required this.bujian,
  });

  bool get isRoleMahasiswa => roleid == 14;
  bool get isStatusAktif => status == 1 && aktif == 1;
  bool get isAbsenAktif => babsen == 1;
  bool get isKrsAktif => bperwalian == 1;
  bool get isUjianAktif => bujian == 1;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      idUsers: json['id_users']?.toString() ?? '',
      userid: json['userid'] is int
          ? json['userid']
          : int.tryParse(json['userid']?.toString() ?? '0') ?? 0,
      nama: json['nama']?.toString() ?? '',
      loginName: json['login_name']?.toString() ?? '',
      pass: json['pass']?.toString() ?? '',
      passSha1: json['pass_sha1']?.toString() ?? '',
      roleid: json['roleid'] is int
          ? json['roleid']
          : int.tryParse(json['roleid']?.toString() ?? '0') ?? 0,
      status: json['status'] is int
          ? json['status']
          : int.tryParse(json['status']?.toString() ?? '0') ?? 0,
      aktif: json['aktif'] is int
          ? json['aktif']
          : int.tryParse(json['aktif']?.toString() ?? '0') ?? 0,
      babsen: json['babsen'] is int
          ? json['babsen']
          : int.tryParse(json['babsen']?.toString() ?? '0') ?? 0,
      bperwalian: json['bperwalian'] is int
          ? json['bperwalian']
          : int.tryParse(json['bperwalian']?.toString() ?? '0') ?? 0,
      bujian: json['bujian'] is int
          ? json['bujian']
          : int.tryParse(json['bujian']?.toString() ?? '0') ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_users': idUsers,
      'userid': userid,
      'nama': nama,
      'login_name': loginName,
      'pass': pass,
      'pass_sha1': passSha1,
      'roleid': roleid,
      'status': status,
      'aktif': aktif,
      'babsen': babsen,
      'bperwalian': bperwalian,
      'bujian': bujian,
    };
  }
}
