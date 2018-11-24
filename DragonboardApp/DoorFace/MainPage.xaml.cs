using System;
using System.IO;
using System.Threading.Tasks;
using Windows.Media.Capture;
using Windows.Media.MediaProperties;
using Windows.Storage;
using Windows.Storage.Streams;
using Windows.System;
using Windows.System.Display;
using Windows.UI.Core;
using Windows.UI.Popups;
using Windows.UI.Xaml;
using Windows.UI.Xaml.Controls;
using Windows.UI.Xaml.Input;
using Windows.UI.Xaml.Media;
using Windows.UI.Xaml.Media.Imaging;

// The Blank Page item template is documented at https://go.microsoft.com/fwlink/?LinkId=402352&clcid=0x409

namespace DoorFace
{
    /// <summary>
    /// An empty page that can be used on its own or navigated to within a Frame.
    /// </summary>
    public sealed partial class MainPage : Page
    {
        MediaCapture mediaCapture;
        bool isPreviewing;
        private DoorbellState currentState = DoorbellState.InitialScreen;

        DisplayRequest displayRequest = new DisplayRequest();

        public MainPage()
        {
            this.InitializeComponent();
        }

        private async Task StartPreviewAsync()
        {
            try
            {

                mediaCapture = new MediaCapture();
                await mediaCapture.InitializeAsync();

                displayRequest.RequestActive();
                CameraCaptureElement.Stretch = Stretch.UniformToFill;
            }
            catch (UnauthorizedAccessException uae)
            {
                // This will be thrown if the user denied access to the camera in privacy settings
                await new MessageDialog("The app was denied access to the camera").ShowAsync();
                return;
            }

            try
            {
                CameraCaptureElement.Source = mediaCapture;
                await mediaCapture.StartPreviewAsync();
                isPreviewing = true;
            }
            catch (FileLoadException)
            {
                mediaCapture.CaptureDeviceExclusiveControlStatusChanged += MediaCaptureOnCaptureDeviceExclusiveControlStatusChanged;
            }

        }

        private async void MediaCaptureOnCaptureDeviceExclusiveControlStatusChanged(MediaCapture sender, MediaCaptureDeviceExclusiveControlStatusChangedEventArgs args)
        {
            if (args.Status == MediaCaptureDeviceExclusiveControlStatus.SharedReadOnlyAvailable)
            {
                await new MessageDialog("The camera preview can't be displayed because another app has exclusive access").ShowAsync();
            }
            else if (args.Status == MediaCaptureDeviceExclusiveControlStatus.ExclusiveControlAvailable && !isPreviewing)
            {
                await Dispatcher.RunAsync(CoreDispatcherPriority.Normal, async () =>
                {
                    await StartPreviewAsync();
                });
            }
        }

        private async void Page_Loaded(object sender, RoutedEventArgs e)
        {
            CoreWindow.GetForCurrentThread().KeyUp += Page_KeyUp;
            await this.StartPreviewAsync();
        }

        private void Page_KeyUp(object sender, KeyEventArgs e)
        {
            if (e.VirtualKey == VirtualKey.Space)
            {
                GoToNextState(false);
            }
        }

        async void GoToNextState(bool calledFromKeyPress, string data = null)
        {
            using (MemoryStream ms = new MemoryStream())
            {
                switch (currentState)
                {
                    case DoorbellState.InitialScreen:
                        this.InitialDisplayGrid.Visibility = Visibility.Collapsed;
                        this.LookIntoCameraGrid.Visibility = Visibility.Visible;
                        this.currentState = DoorbellState.TakingPicture;
                        break;
                    case DoorbellState.TakingPicture:
                        this.LookIntoCameraGrid.Visibility = Visibility.Collapsed;
                        this.VerifyingPersonGrid.Visibility = Visibility.Visible;
                        await this.mediaCapture.CapturePhotoToStreamAsync(ImageEncodingProperties.CreateJpeg(), ms.AsRandomAccessStream());
                        ms.Position = 0;
                        BitmapImage imagePreview = new BitmapImage();
                        imagePreview.SetSource(ms.AsRandomAccessStream());
                        this.VerifyingPreviewImage.Source = imagePreview;
                        this.currentState = DoorbellState.VerifyingPicture;
                        break;
                    case DoorbellState.VerifyingPicture:
                        if (calledFromKeyPress) return;
                        this.VerificationCompleteStatusTextBlock.Text = String.IsNullOrWhiteSpace(data) ? "You are not a verified user. This incident will be reported." : $"Welcome, {data}!";
                        this.VerifyingPersonGrid.Visibility = Visibility.Collapsed;
                        this.VerificationCompleteGrid.Visibility = Visibility.Visible;
                        this.currentState = DoorbellState.VerificationResponse;
                        break;
                    case DoorbellState.VerificationResponse:
                        this.VerificationCompleteGrid.Visibility = Visibility.Collapsed;
                        this.InitialDisplayGrid.Visibility = Visibility.Visible;
                        this.currentState = DoorbellState.InitialScreen;
                        break;
                }
            }
        }
    }

    enum DoorbellState
    {
        InitialScreen,
        TakingPicture,
        VerifyingPicture,
        VerificationResponse
    }
}
