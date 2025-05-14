// package com.example.hands_test

// import android.content.Context
// import android.graphics.Bitmap
// import android.graphics.ImageDecoder
// import android.net.Uri
// import android.os.Build
// import android.provider.MediaStore
// import android.view.View
// import android.view.ViewGroup
// import android.widget.ImageView
// import androidx.constraintlayout.widget.ConstraintLayout
// import androidx.constraintlayout.widget.ConstraintSet
// import androidx.lifecycle.lifecycleScope
// import com.google.mediapipe.framework.image.BitmapImageBuilder
// import com.google.mediapipe.tasks.core.BaseOptions
// import com.google.mediapipe.tasks.vision.core.RunningMode
// import com.google.mediapipe.tasks.vision.handlandmarker.HandLandmark
// import com.google.mediapipe.tasks.vision.handlandmarker.HandLandmarker
// import com.google.mediapipe.tasks.vision.handlandmarker.HandLandmarker.HandLandmarkerOptions
// import io.flutter.plugin.platform.PlatformView
// import io.flutter.plugins.videoplayer.Messages.PlatformVideoViewCreationParams
// import kotlinx.coroutines.Dispatchers
// import kotlinx.coroutines.launch
// import kotlinx.coroutines.withContext

// class MyImageView(
//     private val context: Context,
//     id: Int,
//     creationParams: Map<String?, Any?>?,
//     private val activity: MainActivity
// ) : PlatformView {
//     private val constraintLayout: ConstraintLayout = ConstraintLayout(context)
//     private val overlayView = OverlayView(context, null)
//     private val imageView = ImageView(context)

//     private val baseOptionsBuilder = BaseOptions.builder().setModelAssetPath("hand_landmarker.task")
//     private val baseOptions = baseOptionsBuilder.build()

//     private val optionsBuilder = HandLandmarkerOptions.builder()
//         .setBaseOptions(baseOptions)
//         .setMinHandDetectionConfidence(0.5f)
//         .setMinTrackingConfidence(0.5f)
//         .setMinHandPresenceConfidence(0.5f)
//         .setNumHands(2)
//         .setRunningMode(RunningMode.IMAGE)
//     private val options = optionsBuilder.build()

//     private var handLandmarker: HandLandmarker? = null

//     override fun getView(): View {
//         return constraintLayout
//     }

//     override fun dispose() {

//     }

//     init {
//         handLandmarker = HandLandmarker.createFromOptions(context, options)
//         constraintLayout.id = View.generateViewId()
//         val layoutParams = ViewGroup.LayoutParams(
//             ViewGroup.LayoutParams.WRAP_CONTENT,
//             ViewGroup.LayoutParams.WRAP_CONTENT
//         )
//         constraintLayout.layoutParams = layoutParams
//         val constraintSet = ConstraintSet()
//         constraintSet.clone(constraintLayout)

//         imageView.id = View.generateViewId()
//         constraintLayout.addView(imageView)
//         imageView.scaleType = ImageView.ScaleType.FIT_XY
//         constraintSet.constrainWidth(imageView.id, ConstraintSet.MATCH_CONSTRAINT)
//         constraintSet.constrainHeight(imageView.id, ConstraintSet.MATCH_CONSTRAINT)
//         constraintSet.connect(
//             imageView.id,
//             ConstraintSet.START,
//             ConstraintSet.PARENT_ID,
//             ConstraintSet.START
//         )
//         constraintSet.connect(
//             imageView.id,
//             ConstraintSet.TOP,
//             ConstraintSet.PARENT_ID,
//             ConstraintSet.TOP
//         )
//         constraintSet.connect(
//             imageView.id,
//             ConstraintSet.END,
//             ConstraintSet.PARENT_ID,
//             ConstraintSet.END
//         )
//         constraintSet.connect(
//             imageView.id,
//             ConstraintSet.BOTTOM,
//             ConstraintSet.PARENT_ID,
//             ConstraintSet.BOTTOM
//         )

//         overlayView.id = View.generateViewId()
//         constraintLayout.addView(overlayView)
//         constraintSet.constrainWidth(overlayView.id, ConstraintSet.MATCH_CONSTRAINT)
//         constraintSet.constrainHeight(overlayView.id, ConstraintSet.MATCH_CONSTRAINT)
//         constraintSet.connect(
//             overlayView.id,
//             ConstraintSet.START,
//             ConstraintSet.PARENT_ID,
//             ConstraintSet.START
//         )
//         constraintSet.connect(
//             overlayView.id,
//             ConstraintSet.TOP,
//             ConstraintSet.PARENT_ID,
//             ConstraintSet.TOP
//         )
//         constraintSet.connect(
//             overlayView.id,
//             ConstraintSet.END,
//             ConstraintSet.PARENT_ID,
//             ConstraintSet.END
//         )
//         constraintSet.connect(
//             overlayView.id,
//             ConstraintSet.BOTTOM,
//             ConstraintSet.PARENT_ID,
//             ConstraintSet.BOTTOM
//         )

//         constraintSet.applyTo(constraintLayout)

//         activity.lifecycleScope.launch {
//             display(Uri.parse(creationParams?.get("imageUrl")?.toString()))
//         }
//     }

//     private suspend fun display(mediaUri: Uri) {
//         withContext(Dispatchers.IO) {
//             if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
//                 val source = ImageDecoder.createSource(
//                     context.contentResolver, mediaUri
//                 )
//                 ImageDecoder.decodeBitmap(source)
//             } else {
//                 MediaStore.Images.Media.getBitmap(
//                     context.contentResolver, mediaUri
//                 )
//             }.copy(Bitmap.Config.ARGB_8888, true)?.let { bitmap ->
//                 val scaledDown = bitmap.scaleDown(512F)
//                 val mpImage = BitmapImageBuilder(scaledDown).build()

//                 val result = handLandmarker?.detect(mpImage)

//                 result?.let {
//                     overlayView.setResults(
//                         it, mpImage.height, mpImage.width
//                     )
//                 }
//                 withContext(Dispatchers.Main) {
//                     imageView.setImageBitmap(bitmap)
//                 }
//             }
//         }
//     }
// }

// private fun Bitmap.scaleDown(targetWidth: Float): Bitmap {
//     if (targetWidth >= width) return this
//     val scaleFactory = targetWidth / width
//     return Bitmap.createScaledBitmap(
//         this,
//         (width * scaleFactory).toInt(),
//         (height * scaleFactory).toInt(),
//         false
//     )
// }