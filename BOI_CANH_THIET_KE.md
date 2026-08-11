# PutMind — Bối cảnh thiết kế

> **Mục đích:** Đây là tài liệu ngắn để designer, Codex, Cursor, Claude hoặc bất kỳ AI/code agent nào đọc trước khi thiết kế UI/UX hoặc viết code giao diện.
>
> **Tài liệu ưu tiên cao hơn:** `DAC_TA_SAN_PHAM.md`.
>
> Nếu có mâu thuẫn giữa file này và `DAC_TA_SAN_PHAM.md`, luôn làm theo `DAC_TA_SAN_PHAM.md`.

---

## 1. PutMind là gì?

PutMind giúp người dùng nhớ **“Tôi đã cất món đồ này ở đâu?”** bằng vòng lặp:

**Chụp ảnh → Nói/nhập nơi cất → Lưu → Tìm lại khi cần**

PutMind không phải inventory manager. Trải nghiệm phải giống một **bộ nhớ ngoài cho đồ vật**.

Tagline:

**Snap it. Say where. Find it later.**

---

## 2. Nguyên tắc thiết kế quan trọng nhất

### Ưu tiên tốc độ

Người dùng phải lưu một món đồ trong vài giây.

### Không biến app thành form nhập dữ liệu

Không thêm:

- Category bắt buộc
- Tag bắt buộc
- Folder
- Form nhiều trường
- Dashboard
- Inventory workflow

### Voice-first, không Voice-only

Người dùng được khuyến khích nói, nhưng luôn có keyboard fallback.

### Local-first / Privacy-first

Thiết kế phải phản ánh:

- Không account ở MVP
- Không PutMind cloud/backend cho dữ liệu cá nhân
- Ảnh và memories lưu local
- Speech on-device khi có thể
- Backup do người dùng tự quản lý
- App Lock tùy chọn

### Không scope creep

Nếu có ý tưởng mới trong lúc thiết kế, không tự thêm vào UI. Ghi lại cho Post-MVP trừ khi đó là lỗi nghiêm trọng về usability, security hoặc data loss.

---

## 3. Chỉ có 4 màn hình chính

### Screen 1 — Unlock

Chỉ xuất hiện khi App Lock được bật.

Nhiệm vụ duy nhất:

**Xác thực → vào Home**

Ưu tiên biometric, PIN là fallback.

Không hiển thị dữ liệu nhạy cảm khi chưa unlock.

---

### Screen 2 — Home

Bố cục chính:

**Trên cùng:** Search bar  
**Ở giữa:** Danh sách Memories  
**Dưới chính giữa:** Camera CTA lớn  
**Góc phù hợp:** Settings

Search bar hỗ trợ:

- Text
- Microphone / voice search

Mỗi Memory card nên hiển thị tối thiểu:

- Ảnh
- Text mô tả ngắn
- Vị trí/mô tả liên quan
- Timestamp

Không chỉ hiển thị ảnh.

Camera phải là CTA nổi bật nhất.

---

### Screen 3 — Camera / Capture

Đây là màn hình quan trọng nhất.

Layout định hướng:

- Khoảng 70% camera/preview
- Khoảng 30% hướng dẫn + audio/voice + transcript + Save

Không cố định tuyệt đối 70/30; phải responsive.

Flow chính thức:

**Camera → Chụp → Voice Guidance → Ghi âm → Transcript → Save**

Sau khi chụp hiển thị:

**“Đây là gì? Bạn để ở đâu?”**

Nếu Voice Guidance ON:

**Chụp → phát hướng dẫn → bắt đầu nghe**

Nếu OFF:

**Chụp → bắt đầu nghe ngay**

Cần có trạng thái trực quan để người dùng biết app đang nghe, ví dụ:

- Waveform
- Mic animation
- “Đang nghe…”

Transcript phải sửa được bằng bàn phím.

Không auto-save ở MVP. Có nút **Save** rõ ràng.

---

### Screen 4 — Settings

Chỉ chứa các mục cần thiết:

- Language
- Voice Guidance ON/OFF
- Daily Reminder ON/OFF + giờ
- App Lock
- Auto-lock interval
- Backup & Restore
- Last Backup
- Upgrade Lifetime
- Restore Purchase
- Privacy
- About

Không thêm cài đặt không cần thiết.

---

## 4. Các thành phần không tính là màn hình chính

### Onboarding

Chỉ xuất hiện lần đầu, tối đa khoảng 3 bước:

1. Snap it.
2. Say where you put it.
3. Find it later.

Không xin tất cả permissions trong onboarding.

### Memory Detail

Mở bằng Bottom Sheet/Modal trên Home, không tạo page thứ 5.

Hiển thị:

- Ảnh lớn
- Transcript
- Vị trí nếu có
- Timestamp
- Edit
- Replace photo
- Delete

### Paywall

Mở khi người dùng Free cố tạo Memory thứ 21.

Không khóa Memories đã tồn tại.

---

## 5. User flows phải giữ nguyên

### Launch

App Lock OFF:

**Open → Home**

App Lock ON:

**Open → Unlock → Home**

### Save

**Home → Camera → Take Photo → Speak/Type → Transcript → Save → Home**

### Search

**Home → Search → Results → Memory Bottom Sheet**

### Reminder

**Notification → Capture flow**

### Settings

**Home → Settings**

---

## 6. Empty State

Khi chưa có Memory, Home phải có empty state rõ ràng.

Ví dụ:

**Your things will appear here.**

**Take a photo and tell PutMind where you stored it.**

Camera CTA vẫn phải nổi bật.

---

## 7. Search UX

Search là hành động quan trọng thứ hai sau Camera.

Phải:

- Luôn dễ thấy trên Home
- Hỗ trợ text và voice
- Cho kết quả nhanh
- Ưu tiên relevance
- Nếu relevance tương đương, ưu tiên Memory mới nhất

Điều này giúp xử lý trường hợp cùng một đồ vật từng được cất ở nhiều vị trí khác nhau.

---

## 8. Voice Guidance UX

Voice Guidance là tính năng hỗ trợ người dùng nói đúng cấu trúc:

**Vật gì + để ở đâu**

Ví dụ:

> “Hộ chiếu, để trong ngăn kéo thứ hai bàn làm việc.”

Yêu cầu UI:

- Có text hướng dẫn ngay cả khi audio OFF
- Toggle nhanh trên Capture screen
- Có cùng setting trong Settings
- Hai vị trí dùng chung một state
- Mặc định ON cho người dùng mới
- Khi tắt, không tự bật lại

Audio được đóng gói sẵn trong app theo locale, không gọi API runtime.

---

## 9. Daily Reminder UX

Mặc định:

**OFF**

Chỉ gợi ý bật sau khi người dùng đã hiểu app, ví dụ sau Memory đầu tiên.

Giờ mặc định đề xuất nếu bật:

**21:00**

Người dùng tự chỉnh được.

Notification phải trung tính, không để lộ dữ liệu nhạy cảm.

Ví dụ:

**“Hôm nay bạn có cần lưu lại món đồ nào không?”**

Không spam quá khoảng một lần/ngày.

---

## 10. App Lock UX

App Lock mặc định OFF.

Nếu bật:

- Ưu tiên biometric
- PIN/password fallback
- Có lựa chọn auto-lock: ngay / 1 phút / 5 phút / 15 phút

Phải giải thích rằng PutMind không có backend để reset PIN qua email.

Không hiển thị ảnh, search history hoặc vị trí đồ vật trước khi unlock.

---

## 11. Backup UX

Trong Settings có:

- Create Backup
- Restore Backup
- Last Backup

Backup là file mã hóa do người dùng tự chọn nơi lưu.

Có thể lưu vào:

- Local files
- iCloud Drive
- Google Drive
- Dropbox
- Máy tính / external storage

Đây không phải PutMind cloud.

Có thể nhắc backup khi đã lâu chưa backup hoặc đã tạo nhiều Memories mới, nhưng không nhắc hàng ngày.

App Lock PIN và Backup Password phải được coi là hai khái niệm khác nhau.

---

## 12. Permission UX

Chỉ hỏi khi cần:

- Camera → khi dùng camera lần đầu
- Microphone/Speech → khi dùng voice lần đầu
- Notification → khi bật reminder
- Biometric → khi bật App Lock

Không xin permission hàng loạt ngay lúc launch.

---

## 13. Monetization UX

### Free

**20 Memories**

Người dùng Free vẫn được:

- Search
- Xem
- Edit
- Delete
- Backup
- Restore

### Paywall

Chỉ xuất hiện khi người dùng cố tạo Memory thứ 21.

Thông điệp chính:

**Unlock unlimited memories — $6.99 lifetime**

Không dùng subscription ở MVP.

Không dùng dark pattern và không khóa dữ liệu cũ.

---

## 14. Localization requirements

MVP hỗ trợ:

- English
- Japanese
- German
- Vietnamese

Thiết kế phải chịu được text length khác nhau.

Không:

- Hard-code chiều rộng label quá chặt
- Gắn text chính vào hình ảnh
- Thiết kế chỉ vừa tiếng Anh

Voice Guidance assets cũng theo locale.

Brand **PutMind** giữ nguyên giữa các thị trường.

---

## 15. Ngôn ngữ trong UI

Ưu tiên từ ngữ đơn giản, thân thiện.

Dùng:

- Memory / Memories
- Save
- Find
- Search
- Backup

Tránh ngôn ngữ kỹ thuật như:

- Record
- Database
- Inventory entry
- Asset management

PutMind phải mang cảm giác **memory utility**, không phải business software.

---

## 16. Những gì designer/AI KHÔNG được tự thêm vào MVP

Không thêm:

- GPS
- Maps
- AI image recognition
- OCR
- Barcode
- Cloud sync
- User account
- Family sharing
- Folder
- Category system
- Tag system phức tạp
- Warranty
- Asset valuation
- Inventory dashboard
- Statistics dashboard
- Social sharing
- Household account
- Smart classification

Các ý tưởng đó chỉ thuộc Post-MVP nếu sau này được chấp thuận.

---

## 17. Tiêu chí đánh giá thiết kế

Một thiết kế PutMind tốt phải trả lời **Có** cho các câu sau:

1. Người mới có hiểu app dùng để làm gì trong vài giây không?
2. Camera có phải hành động nổi bật nhất trên Home không?
3. Người dùng có thể lưu một Memory mà không điền form dài không?
4. Có thể hoàn thành flow lưu chỉ trong vài thao tác không?
5. Có keyboard fallback khi không muốn nói không?
6. Search có luôn dễ tiếp cận không?
7. Privacy/local-first có được phản ánh đúng, không gây hiểu nhầm về cloud không?
8. UI có hỗ trợ 4 locale MVP không?
9. Có giữ đúng 4 màn hình chính không?
10. Có tránh tự thêm tính năng ngoài scope không?

Nếu bất kỳ câu nào trả lời “Không”, cần xem lại thiết kế trước khi implementation.

---

## 18. Tóm tắt để AI đọc trong 20 giây

PutMind là app local-first giúp người dùng nhớ nơi cất đồ.

Core loop:

**CHỤP → NÓI/NHẬP → LƯU → TÌM**

4 màn hình:

**Unlock / Home / Camera / Settings**

Home:

**Search trên cùng + Memories ở giữa + Camera lớn phía dưới.**

Camera:

**Chụp → “Đây là gì? Bạn để ở đâu?” → nói/nhập → transcript → Save.**

MVP:

- 20 Memories free
- $6.99 lifetime unlimited
- No account
- No backend
- No cloud database
- Local storage
- Encrypted manual backup
- Optional App Lock
- Optional Daily Reminder
- Voice Guidance packaged in app
- EN / JA / DE / VI

Không thêm feature ngoài `DAC_TA_SAN_PHAM.md`.
