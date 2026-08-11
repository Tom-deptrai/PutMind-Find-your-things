# PutMind — Đặc tả sản phẩm MVP

> **Trạng thái:** Product Spec v1 — MVP scope đã khóa.
>
> **Vai trò:** Đây là **source of truth** của dự án PutMind. Nếu có mâu thuẫn giữa tài liệu này với tài liệu khác, issue, prompt AI hoặc đề xuất trong quá trình thiết kế/code, tài liệu này được ưu tiên.
>
> **Quy tắc scope:** Không tự ý bổ sung tính năng vào MVP. Mọi ý tưởng mới phải đưa vào mục **Post-MVP Backlog**, trừ khi thay đổi đó xử lý lỗi nghiêm trọng về usability, bảo mật, mất dữ liệu, monetization hoặc kiến trúc.

---

## 1. Tên và định vị sản phẩm

**Tên:** PutMind  
**Store title dự kiến:** PutMind: Find Your Things  
**Tagline:** Snap it. Say where. Find it later.

PutMind là ứng dụng giúp người dùng ghi nhớ vị trí các đồ vật trong đời sống thực bằng một thao tác rất nhanh:

**Chụp ảnh → Nói nơi cất → Lưu → Tìm lại khi cần**

PutMind không phải ứng dụng quản lý kho, inventory hay asset management phức tạp. Sản phẩm được định vị như một **“bộ nhớ ngoài cho đồ vật trong cuộc sống thực.”**

---

## 2. Vấn đề cần giải quyết

Người dùng thường quên nơi đã cất các món đồ ít sử dụng như:

- Hộ chiếu, giấy tờ quan trọng
- Chìa khóa dự phòng
- Sạc, dây cáp, thiết bị điện tử
- Dụng cụ, phụ kiện
- Đồ trong tủ, kho, garage, attic
- Đồ đóng thùng khi chuyển nhà
- Đồ theo mùa
- Các món chỉ vài tuần hoặc vài tháng mới cần dùng

Các giải pháp hiện tại thường có friction:

- Ghi chú tay hoặc app Notes phải nhập nhiều
- Ảnh trong thư viện khó tìm theo ý nghĩa “để ở đâu”
- AirTag cần phần cứng riêng và phù hợp hơn với đồ thường xuyên di chuyển
- App inventory thường quá nhiều trường dữ liệu

PutMind giải quyết bằng thao tác ngắn nhất có thể: **chụp, nói, lưu**.

---

## 3. Giá trị cốt lõi

Người dùng tự mô tả bằng giọng nói thay vì phụ thuộc vào AI nhận diện hình ảnh.

Ví dụ:

> “Hộ chiếu, để trong ngăn kéo thứ hai bàn làm việc.”

Lợi ích:

- Người dùng xác định chính xác vật gì và vị trí ở đâu
- Giảm rủi ro AI vision nhận sai
- Không cần API AI trả phí theo lượt
- Giảm chi phí vận hành
- Tăng quyền riêng tư
- Có thể hoạt động offline trong nhiều trường hợp
- UX đơn giản, dễ hiểu

---

## 4. Vòng lặp cốt lõi

### Khi cất đồ

**Mở PutMind → Camera → Chụp → Nói/nhập → Lưu**

### Khi cần tìm

**Mở PutMind → Search → Gõ/Nói → Xem ảnh + vị trí đã lưu**

Toàn bộ sản phẩm xoay quanh hai hành động:

**GHI NHỚ** và **TÌM LẠI**.

---

## 5. Nguyên tắc UX

PutMind phải cực kỳ đơn giản.

Người dùng không nên cảm thấy:

> “Tôi đang nhập dữ liệu vào một hệ thống.”

Mà nên cảm thấy:

> “Tôi đang lưu lại một ký ức.”

### Không có trong MVP

- Form dài
- Category bắt buộc
- Tag bắt buộc
- Folder
- Dashboard
- Quản lý inventory kiểu doanh nghiệp

### Mục tiêu UX

Từ lúc mở app đến khi lưu xong một món đồ chỉ mất vài giây.

PutMind là **voice-first**, nhưng không **voice-only**. Người dùng luôn có thể nhập bằng bàn phím nếu không muốn hoặc không thể nói.

---

## 6. Cấu trúc giao diện

PutMind có **4 màn hình chính**:

1. Unlock
2. Home
3. Camera / Capture
4. Settings

Ngoài ra có:

- Onboarding: chỉ xuất hiện lần đầu
- Memory Detail: Bottom Sheet/Modal
- Paywall: Modal/Sheet
- Dialog/Sheet cho delete, permissions, backup, v.v.

Các phần này không tính là màn hình chính.

---

## 7. Màn hình Unlock

Chỉ xuất hiện nếu người dùng đã bật App Lock.

### Hỗ trợ

Ưu tiên biometric:

- Face ID
- Touch ID
- Fingerprint / biometric tương ứng trên Android

Fallback:

- PIN
- Mật khẩu nếu implementation chọn hỗ trợ

### Auto-lock

Người dùng có thể chọn:

- Khóa ngay khi thoát app
- Sau 1 phút
- Sau 5 phút
- Sau 15 phút

### Mặc định

**App Lock = OFF**

### Khi app bị khóa

Không được hiển thị:

- Ảnh đồ vật
- Vị trí đồ vật
- Lịch sử hoặc nội dung tìm kiếm
- Nội dung nhạy cảm trong notification

### Bảo mật kỹ thuật

Không lưu PIN/mật khẩu dạng plain text.

Sử dụng cơ chế bảo mật hệ điều hành như:

- iOS Keychain
- Android Keystore / secure storage

### Quên PIN

PutMind không có account/backend nên không có luồng gửi email reset mật khẩu.

Nếu người dùng quên PIN nhưng biometric vẫn hoạt động:

**Biometric → vào app → Settings → đổi PIN**

Nếu không còn cách xác thực hợp lệ, PutMind không thể reset từ server vì không có server lưu tài khoản người dùng.

Khi bật App Lock phải giải thích rõ nguyên tắc này.

---

## 8. Màn hình Home

### Phía trên

Thanh Search hỗ trợ:

- Text input
- Voice search
- Icon microphone trong search bar

### Phần giữa

Danh sách các **Memories** đã lưu.

Không dùng ngôn ngữ kỹ thuật như “database record” hay “inventory item” trong UI người dùng.

Mỗi card nên có:

- Ảnh
- Mô tả ngắn / transcript phù hợp
- Vị trí
- Thời gian lưu

Không chỉ hiển thị ảnh; text phải luôn có để người dùng nhận biết nhanh.

### Phía dưới

Một nút **Camera lớn** nằm chính giữa đáy màn hình.

Đây là CTA quan trọng nhất của app.

### Settings

Có icon Settings ở vị trí dễ tiếp cận, không cần bottom navigation cho MVP.

---

## 9. Empty State của Home

Khi chưa có Memory nào, không để màn hình trống hoàn toàn.

Ví dụ:

**Your things will appear here.**

**Take a photo and tell PutMind where you stored it.**

Nút Camera vẫn phải là điểm nhấn chính.

---

## 10. Memory Detail

Không tạo màn hình thứ 5.

Khi người dùng chạm một Memory trên Home, mở **Bottom Sheet/Modal**.

Hiển thị:

- Ảnh lớn
- Transcript/mô tả
- Vị trí nếu được suy ra/hiển thị riêng
- Thời gian tạo
- Thời gian cập nhật nếu có

Actions:

- Edit
- Replace photo
- Delete

Delete cần confirmation:

> Delete this memory?

MVP không cần Trash/Recently Deleted.

---

## 11. Màn hình Camera / Capture

Đây là màn hình quan trọng nhất của sản phẩm.

### Layout định hướng

Khoảng:

- 70% phía trên: camera/preview
- 30% phía dưới: hướng dẫn, ghi âm, transcript, controls

Không cố định tỷ lệ tuyệt đối; UI phải responsive theo kích thước màn hình.

---

## 12. Capture Flow chính thức

**Camera → Chụp → Voice Guidance → Ghi âm → Transcript → Save**

### Bước 1

Mở Camera.

### Bước 2

Người dùng chụp ảnh.

### Bước 3

App giữ ảnh preview.

### Bước 4

Hiển thị hướng dẫn:

**“Đây là gì? Bạn để ở đâu?”**

Mục tiêu là giúp người dùng luôn nói đủ hai thông tin:

- Vật gì
- Để ở đâu

Ví dụ:

> “Sạc MacBook, để trong ngăn trên cùng tủ phòng ngủ.”

### Bước 5

Nếu Voice Guidance đang bật, phát audio hướng dẫn trước khi bắt đầu nghe.

### Bước 6

Bắt đầu ghi/nhận dạng giọng nói. Có thể dùng beep/animation/waveform để thể hiện trạng thái đang nghe.

### Bước 7

Hiển thị transcript.

### Bước 8

Người dùng có thể sửa transcript bằng bàn phím.

### Bước 9

Người dùng nhấn **Save**.

### Bước 10

Trở về Home.

**Không auto-save trong MVP.** Save là hành động xác nhận cuối cùng.

---

## 13. Voice Guidance

Voice Guidance là câu hướng dẫn phát bằng giọng nói tự nhiên theo ngôn ngữ người dùng.

Ví dụ tiếng Việt:

> “Đây là gì? Bạn để ở đâu?”

Sau khi phát xong, app bắt đầu nghe người dùng.

### Nguyên tắc

- File audio được tạo sẵn
- Đóng gói trực tiếp trong app
- Không gọi API TTS lúc runtime
- Không phát sinh chi phí API khi người dùng sử dụng
- Giọng tự nhiên, thân thiện, ngắn, rõ
- Mỗi locale có asset tương ứng

Ví dụ:

- `vi-VN.mp3`
- `en-US.mp3`
- `ja-JP.mp3`
- `de-DE.mp3`

Có thể dùng AI coding agent để hỗ trợ tìm nguồn, tạo script, chuẩn hóa file và tích hợp assets, nhưng chỉ sử dụng audio có **license rõ ràng cho commercial use và redistribution trong app**. Nên lưu bằng chứng license trong repo khi triển khai.

---

## 14. Voice Guidance On/Off

Có toggle:

**Voice Guidance / Hướng dẫn bằng giọng nói**

Xuất hiện:

- Trên Capture Screen để tắt/bật nhanh
- Trong Settings

Hai vị trí phải dùng cùng một trạng thái.

### Nếu ON

**Chụp → phát hướng dẫn → bắt đầu nghe**

### Nếu OFF

**Chụp → bắt đầu nghe ngay**

Dù OFF, dòng chữ:

**“Đây là gì? Bạn để ở đâu?”**

vẫn hiển thị.

### Mặc định

**ON cho người dùng mới**.

Khi người dùng tắt, phải ghi nhớ lựa chọn và không tự bật lại.

---

## 15. Voice-first, không Voice-only

Người dùng có thể:

- Nói
- Hoặc nhập text

Lý do:

- Đang ở nơi công cộng
- Không muốn nói thành tiếng
- Môi trường ồn
- Speech recognition sai
- Thiết bị/ngôn ngữ không hỗ trợ tốt on-device speech

Keyboard fallback là yêu cầu bắt buộc để core flow luôn dùng được.

---

## 16. Speech-to-Text

Ưu tiên nhận dạng **on-device** khi hệ điều hành, thiết bị và locale hỗ trợ.

Mục tiêu:

- Không upload audio lên server PutMind
- Không có chi phí API speech theo lượt
- Có khả năng hoạt động offline

### iOS

Dùng Speech framework / on-device recognition khi supported.

### Android

Dùng on-device SpeechRecognizer khi thiết bị hỗ trợ; không giả định mọi SpeechRecognizer đều offline.

### Fallback

Nếu speech không khả dụng:

- Cho người dùng nhập text
- Không để app unusable

Product promise nên nói theo hướng **on-device preferred**, không cam kết tuyệt đối mọi ngôn ngữ/thiết bị đều offline nếu chưa được xác minh.

---

## 17. Transcript

Transcript là dữ liệu chính được tạo từ giọng nói hoặc nhập bằng bàn phím.

Người dùng phải có thể:

- Xem transcript
- Chạm vào để sửa
- Sửa lỗi nhận dạng trước khi Save

---

## 18. Cấu trúc dữ liệu một Memory

### Bắt buộc

- ID
- Image
- Full transcript
- Created time
- Updated time

### Có thể suy ra nội bộ

- Item name
- Location text

### Quy tắc MVP

**Full transcript là nguồn dữ liệu chính.**

Không bắt người dùng nhập riêng:

- Item name
- Location
- Category
- Tag

Về sau có thể tách “Vật gì” và “Ở đâu” bằng logic/AI nếu hữu ích, nhưng không được làm Capture UX phức tạp hơn.

---

## 19. GPS

**Không có GPS trong MVP.**

Lý do:

- Phần lớn use case là vị trí tương đối trong nhà: ngăn kéo, tủ, hộp, garage...
- GPS không giúp xác định chính xác vị trí trong nhà
- Tăng permission và privacy concern
- Không đáng với complexity ở MVP

Có thể xem xét lại sau nếu xuất hiện use case đa địa điểm như nhà, văn phòng, kho, nhà người thân.

---

## 20. Khi một đồ vật thay đổi vị trí

MVP cho phép tồn tại nhiều Memories về cùng một vật.

Ví dụ:

- Tháng trước: Passport → ngăn kéo
- Hôm nay: Passport → vali

Search phải ưu tiên kết quả mới nhất khi relevance tương đương.

Không cần tính năng “Update existing item?” trong MVP.

---

## 21. Search

Search nằm trên Home và hỗ trợ:

- Text
- Voice
- Full-text search
- Fuzzy / near-match search

Search trên:

- Transcript
- Item name nếu được suy ra
- Location nếu được suy ra
- Metadata phù hợp

### Thứ tự kết quả

1. Relevance
2. Newest first nếu relevance tương đương

Mục tiêu là tìm được nhanh ngay cả khi speech-to-text hoặc truy vấn có sai khác nhỏ.

---

## 22. Daily Reminder

Mục tiêu là giải quyết tình huống người dùng đã cất đồ nhưng quên mở PutMind để lưu.

Ví dụ notification:

**“Hôm nay bạn có cần lưu lại món đồ nào không?”**

### Mặc định

**Daily Reminder = OFF**

Sau khi người dùng đã hiểu sản phẩm hoặc lưu Memory đầu tiên, app có thể gợi ý bật reminder.

Chỉ xin notification permission khi người dùng chủ động bật.

### Giờ mặc định đề xuất

Khoảng **21:00**.

Người dùng có thể tự chọn giờ.

### Quy tắc

- Tối đa khoảng 1 lần/ngày
- Không spam
- Không đưa tên/vị trí đồ vật nhạy cảm vào notification
- Tap notification → mở nhanh Capture flow

---

## 23. Màn hình Settings

Settings chỉ chứa các mục cần thiết:

### Language

- Chọn ngôn ngữ app
- Ảnh hưởng UI, Voice Guidance và speech locale phù hợp

### Voice Guidance

- ON/OFF

### Daily Reminder

- ON/OFF
- Chọn giờ

### App Lock

- ON/OFF
- Biometric
- PIN/password fallback
- Auto-lock interval

### Backup & Restore

- Create Backup
- Restore Backup
- Last Backup

### Purchase

- Upgrade Lifetime
- Restore Purchase

### Privacy

- Thông tin privacy

### About

- Version
- Basic app info

Không thêm Settings thừa ở MVP.

---

## 24. Local-first Architecture

Dữ liệu người dùng nằm trên thiết bị của họ.

PutMind MVP không cần:

- Account
- Backend riêng
- Cloud database
- Server chứa ảnh
- Server chứa transcript

Mục tiêu:

- Giảm chi phí vận hành
- Tăng quyền riêng tư
- Giảm phụ thuộc hạ tầng
- Core functionality có thể hoạt động độc lập

---

## 25. Backup & Restore

Nếu người dùng xóa app, dữ liệu local có thể mất. PutMind giải quyết bằng **encrypted backup file** do người dùng tự quản lý.

### Create Backup

Đóng gói:

- SQLite database
- Images
- Transcript
- Metadata cần thiết

thành một file backup, ví dụ:

`PutMindBackup.backup`

### Bảo mật

Backup nên được mã hóa.

Không xuất plain ZIP chứa ảnh và dữ liệu nhạy cảm.

### Nơi lưu

Người dùng tự chọn:

- Bộ nhớ máy
- Máy tính
- External storage
- iCloud Drive
- Google Drive
- Dropbox
- File provider khác

Nếu người dùng chọn cloud, đó là cloud/tài khoản của chính họ; PutMind không vận hành cloud storage và không phải trả phí lưu dữ liệu của họ.

### Restore

**Settings → Restore Backup → chọn file → phục hồi dữ liệu**

Dùng khi:

- Cài lại app
- Đổi máy
- Xóa rồi cài lại

---

## 26. Nhắc Backup

Backup thủ công dễ bị quên.

App có thể theo dõi:

- Last backup date
- Số Memories tạo từ lần backup gần nhất

Ví dụ:

> “Bạn đã thêm 25 memories kể từ lần sao lưu gần nhất. Sao lưu ngay?”

Hoặc:

> “Đã 30 ngày kể từ lần sao lưu gần nhất.”

Không nhắc hàng ngày.

---

## 27. App Lock Password và Backup Password

Hai khái niệm phải tách biệt.

### App Lock PIN

Bảo vệ app trên thiết bị hiện tại.

### Backup Password

Bảo vệ file backup có thể mang sang thiết bị khác.

Không mặc định xem hai password là một.

Nếu encrypted backup dùng password do người dùng đặt và người dùng quên password, backup có thể không phục hồi được. UX phải giải thích rõ trước khi tạo backup.

Implementation encryption/recovery chi tiết sẽ được chốt ở giai đoạn kỹ thuật, nhưng yêu cầu sản phẩm là **backup không được để dữ liệu nhạy cảm ở dạng đọc được trực tiếp**.

---

## 28. Quyền riêng tư

Định hướng privacy của PutMind:

- No account
- No mandatory cloud
- No PutMind backend cho dữ liệu cá nhân
- No photo upload to PutMind
- Local-first storage
- On-device speech preferred
- Encrypted backup
- Optional App Lock

Thông điệp có thể dùng:

**Your memories stay yours.**

Hoặc:

**Your things. Your memories. Your device.**

---

## 29. Permission Strategy

Không xin toàn bộ permissions ngay lúc mở app lần đầu.

### Camera

Xin khi người dùng lần đầu vào Capture/cần camera.

### Microphone / Speech

Xin khi người dùng lần đầu dùng voice.

### Notification

Chỉ xin khi người dùng bật Daily Reminder.

### Biometric

Chỉ xin khi người dùng bật App Lock.

Nguyên tắc:

**Ask only when needed.**

---

## 30. Onboarding

Onboarding chỉ xuất hiện lần đầu, không tính là màn hình chính.

Tối đa khoảng 3 bước:

1. **Snap it.**
2. **Say where you put it.**
3. **Find it later.**

Mục tiêu là giúp người dùng hiểu app trong vài giây.

Không onboarding dài và không xin permissions hàng loạt trong onboarding.

---

## 31. Monetization

Không dùng subscription ở MVP.

### Free

Cho phép tối đa **20 Memories**.

Người dùng Free vẫn có thể:

- Search
- Xem dữ liệu đã lưu
- Edit
- Delete
- Backup
- Restore

Không khóa hoặc xóa dữ liệu hiện có.

### Khi tạo Memory thứ 21

Hiển thị paywall:

**Unlock unlimited memories — $6.99 lifetime**

### Lifetime

Giá khởi đầu:

**$6.99**

Mở khóa:

- Unlimited Memories

Sau khi sản phẩm có traction/review tốt có thể thử mức giá khác, nhưng giá MVP hiện tại được chốt ở $6.99 lifetime.

---

## 32. Đối tượng và use case mục tiêu

Không định vị chính bằng chìa khóa/vali đang di chuyển vì phần cứng tracker như AirTag mạnh ở các use case đó.

PutMind tập trung vào **đồ đã được cất tại một vị trí nhưng người dùng có thể quên vị trí đó**.

Use cases tốt:

- Hộ chiếu, giấy tờ
- Spare keys
- Chargers/cables
- Electronics
- Storage box
- Closet
- Garage
- Attic
- Seasonal items
- Đồ ít dùng
- Moving boxes

### Use case chuyển nhà

Ví dụ:

> “Cáp máy ảnh Sony, box 17.”

Sau này tìm “Cáp Sony” → thấy Memory cho biết **Box 17**.

---

## 33. Ngôn ngữ MVP

Chốt 4 ngôn ngữ ban đầu:

1. English
2. Japanese
3. German
4. Vietnamese

UI phải được thiết kế localization-ready từ đầu:

- Không hard-code chiều rộng text
- Hỗ trợ text dài/ngắn theo locale
- Không đặt text quan trọng trực tiếp vào hình ảnh
- Voice assets theo locale

### Mở rộng sau MVP

Có thể ưu tiên:

- Korean
- French
- Spanish
- Portuguese
- Italian
- Traditional Chinese

---

## 34. Branding và Localization trên Store

Brand **PutMind** giữ nhất quán trên toàn thế giới.

Phần mô tả phía sau có thể localize theo thị trường.

Ví dụ English:

**PutMind: Find Your Things**

Store metadata nên được tối ưu riêng cho từng locale, không chỉ dịch word-for-word.

### ASO direction tiếng Anh

Store title:

**PutMind: Find Your Things**

Subtitle:

**Remember Where You Put It**

Tagline:

**Snap it. Say where. Find it later.**

Keyword concepts:

- find my things
- where did I put it
- item finder
- find stored items
- remember where things are
- find my stuff
- storage organizer
- belongings tracker
- storage box finder
- moving box organizer

Không nhồi từ khóa “AI” nếu AI không phải giá trị cốt lõi của sản phẩm.

---

## 35. Công nghệ MVP — định hướng

Quyết định framework cuối cùng sẽ được chốt ở giai đoạn implementation.

### Mobile

- iOS + Android
- Có thể cân nhắc Flutter, React Native hoặc native

### Database

- SQLite

### Search

- SQLite Full-Text Search
- Fuzzy matching

### Images

- Lưu local

### Speech

- Native/on-device speech APIs khi hỗ trợ

### Voice Guidance

- Audio assets đóng gói sẵn

### Security

- Keychain / Keystore
- Biometric APIs

### Backup

- Encrypted archive/file

---

## 36. Những thứ KHÔNG có trong MVP

Để tránh scope creep, không tự thêm:

- AI image recognition
- OCR
- Barcode
- Cloud sync
- User account
- Family sharing
- Folder
- Category system
- Tag system phức tạp
- Warranty management
- Asset valuation
- Home inventory dashboard
- Maps
- GPS
- Household accounts
- Smart classification
- Statistics dashboard cho user
- Social sharing

Nếu ý tưởng mới xuất hiện, đưa vào **Post-MVP Backlog** thay vì thay đổi MVP hiện tại.

---

## 37. Post-MVP Backlog

Chỉ xem xét sau khi MVP chứng minh retention/product value.

Có thể gồm:

- Cloud sync tùy chọn
- Family sharing
- Update existing item detection
- Smart item extraction
- Smart location extraction
- More languages
- Widget
- Shortcut / Quick Capture
- Semantic search nâng cao
- Auto-backup integration
- AI features nếu chứng minh được giá trị thực

---

## 38. Metrics cần đo

Rủi ro lớn nhất của PutMind là **retention/thói quen**, không phải khả năng kỹ thuật.

### Activation

- % người tạo Memory đầu tiên
- Thời gian từ install → Memory đầu tiên

### Usage

- % người tạo Memory thứ 5
- % người tạo Memory thứ 10
- % người đạt 20 Memories

### Search

- % người quay lại dùng Search
- Search success rate
- Số lần search/user

### Retention

- D1
- D7
- D30

Cần đọc retention theo bản chất utility: người dùng quay lại sau 2 tuần để tìm đúng một món đồ vẫn có thể là user có giá trị cao.

### Monetization

- Free → Lifetime conversion
- Conversion tại Memory thứ 21
- Revenue per install

---

## 39. Giả thuyết quan trọng nhất cần chứng minh

Camera, SQLite, speech-to-text và search đều khả thi về kỹ thuật.

Rủi ro lớn nhất là:

> **Người dùng có nhớ mở PutMind khi họ cất đồ và tiếp tục sử dụng nó hay không?**

MVP cần theo dõi người dùng có tiếp tục đến:

- Memory 5
- Memory 10
- Memory 20

Nếu phần lớn chỉ tạo 2–3 Memories rồi bỏ, vấn đề retention chưa được giải quyết.

---

## 40. Các cơ chế giảm friction/thói quen

- Camera CTA lớn
- Chụp → Nói → Lưu
- Không form dài
- Voice Guidance: “Đây là gì? Bạn để ở đâu?”
- Keyboard fallback
- Daily Reminder tùy chọn
- Search ngay trên Home
- Không bắt category/tag/folder

Mục tiêu là làm hành động ghi nhớ nhanh đến mức người dùng sẵn sàng dùng ngay lúc cất đồ.

---

## 41. Product Promise

Thông điệp chính:

**You don’t have to remember where you put things. PutMind does.**

Hoặc:

**Snap it. Say where. Find it later.**

Không truyền đạt quá nhiều tính năng cùng lúc trong UI chính.

---

## 42. Kiến trúc UX cuối cùng

### Launch

Nếu App Lock OFF:

**Open app → Home**

Nếu App Lock ON:

**Open app → Unlock → Home**

### Save Flow

**Home → Camera → Take Photo → Voice Guidance → Speak/Type → Transcript → Save → Home**

### Search Flow

**Home → Search → Results → Memory Bottom Sheet**

### Settings Flow

**Home → Settings**

---

## 43. Trạng thái scope

**MVP scope được coi là đã khóa trước khi bắt đầu thiết kế.**

Trong quá trình UX/UI hoặc implementation:

- Không tự ý thêm feature mới
- Không biến PutMind thành inventory manager
- Không thêm backend/cloud chỉ vì tiện implementation
- Không thay đổi monetization hoặc giới hạn 20 Memories nếu chưa có quyết định sản phẩm mới
- Không thêm màn hình chính nếu không thật sự cần

Nếu phát hiện ý tưởng mới, ghi vào Post-MVP Backlog.

Chỉ thay đổi spec nếu phát hiện vấn đề nghiêm trọng ảnh hưởng trực tiếp tới:

- Usability
- Security
- Data loss
- Monetization
- Architecture

---

## 44. Tóm tắt một câu

**PutMind là ứng dụng local-first giúp người dùng chụp một món đồ, nói nơi đã cất và tìm lại vị trí của nó chỉ trong vài giây khi cần.**

## 45. Tóm tắt vòng lặp

**CHỤP → NÓI/NHẬP → LƯU → TÌM → NHỚ LẠI**

## 46. Triết lý sản phẩm

**Simple enough to use in seconds.**  
**Private enough to trust with important things.**  
**Useful enough to save you when memory fails.**
