using System.Collections;
using UnityEngine;
using System;
using UnityOSC;
[RequireComponent (typeof (AudioSource))] // 

public class AudioPeer : MonoBehaviour {
    AudioSource _audiosource;
    private OSCReciever reciever;
    //public OSC osc;
    public int port;
    public static float[] _samples = new float[512]; // takes all the hertz in the total spectrum of the audio playing, 20000 samples, and put´s them into 512 samples
    public static float[] _freqBand = new float[8];
    public static float[] _bandBuffer = new float[8];
    public static float[] _bufferDecrease = new float[8];

    float[] _freqBandHighest = new float[8];
    public static float[] _audioBand = new float[8];
    public static float[] _audioBandBuffer = new float[8];

    // Use this for initialization
    void Start () {
        reciever = new OSCReciever();
        reciever.Open(port);
        _audiosource = GetComponent<AudioSource> ();
        //osc.SetAddressHandler("/audio", GetSpectrumAudioSource);
        
        for (int i = 0; i > 512; i++)
        {
            _samples[i] = 0.0f;
        }

    }

    // Update is called once per frame
    void Update () {
        GetSpectrumAudioSource ();
        MakeFrequencyBands ();
        Bandbuffer ();
        CreateAudioBands ();

    }

    void CreateAudioBands () { // create values between zero and one that can be apllied to a lot of different outputs
        for (int i = 0; i < 8; i++) {
            if (_freqBand[i] > _freqBandHighest[i]) {
                _freqBandHighest[i] = _freqBand[i];
            }
            _audioBand[i] = (_freqBand[i] / _freqBandHighest[i]);
            if (float.IsNaN(_audioBand[i]))
                _audioBand[i] = 0f;
            _audioBandBuffer[i] = (_bandBuffer[i] / _freqBandHighest[i]);
            if (float.IsNaN(_audioBandBuffer[i]))
                _audioBandBuffer[i] = 0f;

        }
    }

    void GetSpectrumAudioSource () {
        //_audiosource.GetSpectrumData (_samples, 0, FFTWindow.Blackman); // takes audio sources spectrum data and puts them into samples
        OSCMessage msg;
        try //Due to the sending rate, there somtimes happens not to be a new message after a new frame
        {
            if (reciever.hasWaitingMessages()) // FFT values
            {
                    msg = reciever.getNextMessage();
                    object[] m = msg.Data.ToArray();
                    _samples = Array.ConvertAll<object, float>(m, o => Convert.ToSingle(o));
            }
            
        }
        catch (InvalidOperationException e)
        {
        }
    }
    void Bandbuffer () //buffer to the value which creates a smooth down when the amplitude is lower than its previous value
    {
        for (int g = 0; g < 8; ++g) {
            if (_freqBand[g] > _bandBuffer[g]) {
                _bandBuffer[g] = _freqBand[g];
                _bufferDecrease[g] = 0.005f;
            }

            if (_freqBand[g] < _bandBuffer[g]) {
                _bandBuffer[g] -= _bufferDecrease[g];
                _bufferDecrease[g] *= 1.2f;
            }
        }

    }

    void MakeFrequencyBands () // divides the 512 samples into eight frequency bands
    {
        int count = 0;
        for (int i = 0; i < 8; i++) {
            float average = 0;
            int sampleCount = (int) Mathf.Pow (2, i) * 2;
            if (i == 7) {
                sampleCount += 2;
            }
            for (int j = 0; j < sampleCount; j++) {
                average += _samples[count] * (count + 1);
                count++;
            }
            average /= count;
            _freqBand[i] = average * 10;

        }

    }

}