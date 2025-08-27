YILDIZ 16-Bit CPU

Bu projede, Verilog HDL kullanılarak donanım seviyesinde YILDIZ isimli 16-bit özel amaçlı bir işlemci tasarlanmıştır. Tasarım, klasik CPU mimarisini temel alan modüllerden oluşmaktadır ve tüm modüller birleştirilerek bütünsel bir işlem birimi oluşturulmuştur.

Ana Modüller
| Dosya                | Açıklama                                                                               |
| -------------------- | -------------------------------------------------------------------------------------- |
| `alu.v`              | Aritmetik ve mantıksal işlemler için ALU (Arithmetic Logic Unit) modülü                |
| `ram_16bit.v`        | 16-bit genişliğinde RAM modülü, veri depolama ve erişim için                           |
| `control_unit.v`     | FSM tabanlı kontrol birimi, komutların sırasını ve sinyallerin yönetimini sağlar       |
| `register_bank.v`    | 8 genel amaçlı register (R0–R7), stack pointer (SP) ve interrupt status register (ISR) |
| `data_path.v`        | Veri yolu (bus) ve modüller arası bağlantıları yöneten modül                           |
| `yildiz_cpu_16bit.v` | Tüm modülleri birleştirerek CPU’yu oluşturan ana top-level modül                       |
| `YildizCPU16_tb.v`   | Testbench; CPU fonksiyonelliğini doğrulamak için simülasyon amaçlı                     |
