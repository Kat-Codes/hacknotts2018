using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Runtime.InteropServices.WindowsRuntime;
using System.Threading.Tasks;
using Windows.Foundation;
using Windows.Foundation.Collections;
using Windows.Graphics.Display;
using Windows.Media.Capture;
using Windows.System.Display;
using Windows.UI.Core;
using Windows.UI.Popups;
using Windows.UI.Xaml;
using Windows.UI.Xaml.Controls;
using Windows.UI.Xaml.Controls.Primitives;
using Windows.UI.Xaml.Data;
using Windows.UI.Xaml.Input;
using Windows.UI.Xaml.Media;
using Windows.UI.Xaml.Navigation;

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
            await this.StartPreviewAsync();
        }
    }
}
