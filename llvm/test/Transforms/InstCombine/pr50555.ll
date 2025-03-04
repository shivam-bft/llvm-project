; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

define void @trunc_one_add(i16* %a, i8 %b) {
; CHECK-LABEL: @trunc_one_add(
; CHECK-NEXT:    [[ZEXT:%.*]] = zext i8 [[B:%.*]] to i32
; CHECK-NEXT:    [[SHR:%.*]] = lshr i32 [[ZEXT]], 1
; CHECK-NEXT:    [[ADD:%.*]] = add nuw nsw i32 [[SHR]], [[ZEXT]]
; CHECK-NEXT:    [[TRUNC:%.*]] = trunc i32 [[ADD]] to i16
; CHECK-NEXT:    store i16 [[TRUNC]], i16* [[A:%.*]], align 2
; CHECK-NEXT:    ret void
;
  %zext = zext i8 %b to i32
  %shr = lshr i32 %zext, 1
  %add = add nsw i32 %zext, %shr
  %trunc = trunc i32 %add to i16
  store i16 %trunc, i16* %a, align 2
  ret void
}

define void @trunc_two_adds(i16* %a, i8 %b, i8 %c) {
; CHECK-LABEL: @trunc_two_adds(
; CHECK-NEXT:    [[ZEXT1:%.*]] = zext i8 [[B:%.*]] to i32
; CHECK-NEXT:    [[ZEXT2:%.*]] = zext i8 [[C:%.*]] to i32
; CHECK-NEXT:    [[ADD1:%.*]] = add nuw nsw i32 [[ZEXT1]], [[ZEXT2]]
; CHECK-NEXT:    [[SHR1:%.*]] = lshr i32 [[ADD1]], 1
; CHECK-NEXT:    [[ADD2:%.*]] = add nuw nsw i32 [[ADD1]], [[SHR1]]
; CHECK-NEXT:    [[SHR2:%.*]] = lshr i32 [[ADD2]], 2
; CHECK-NEXT:    [[TRUNC:%.*]] = trunc i32 [[SHR2]] to i16
; CHECK-NEXT:    store i16 [[TRUNC]], i16* [[A:%.*]], align 2
; CHECK-NEXT:    ret void
;
  %zext1 = zext i8 %b to i32
  %zext2 = zext i8 %c to i32
  %add1 = add nuw nsw i32 %zext1, %zext2
  %shr1 = lshr i32 %add1, 1
  %add2 = add nuw nsw i32 %add1, %shr1
  %shr2 = lshr i32 %add2, 2
  %trunc = trunc i32 %shr2 to i16
  store i16 %trunc, i16* %a, align 2
  ret void
}
