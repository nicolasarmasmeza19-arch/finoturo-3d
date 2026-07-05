using UnityEngine;
using TMPro;

/// <summary>
/// Gestor de la interfaz de usuario del juego.
/// Controla HUD, inventario, menús y pantallas.
/// </summary>
public class UIManager : MonoBehaviour
{
    [Header("HUD Elementos")]
    [SerializeField] private TextMeshProUGUI moneyText;
    [SerializeField] private TextMeshProUGUI levelText;
    [SerializeField] private TextMeshProUGUI experienceText;
    [SerializeField] private TextMeshProUGUI missionText;
    [SerializeField] private TextMeshProUGUI timeText;
    [SerializeField] private Image energyBar;

    [Header("Paneles")]
    [SerializeField] private GameObject pauseMenuPanel;
    [SerializeField] private GameObject inventoryPanel;
    [SerializeField] private GameObject missionPanel;
    [SerializeField] private GameObject dialogPanel;

    [Header("Referencias")]
    private PlayerController playerController;
    private EconomyManager economyManager;
    private MissionManager missionManager;

    private bool isPauseMenuOpen = false;
    private bool isInventoryOpen = false;

    private void Start()
    {
        InitializeUI();
    }

    private void Update()
    {
        UpdateHUD();
        HandleInputs();
    }

    /// <summary>
    /// Inicializa la interfaz
    /// </summary>
    private void InitializeUI()
    {
        // Obtener referencias de managers
        playerController = GameManager.Instance.GetPlayerController();
        economyManager = GameManager.Instance.GetEconomyManager();
        missionManager = GameManager.Instance.GetMissionManager();

        Debug.Log("[UIManager] Interfaz inicializada");
    }

    /// <summary>
    /// Actualiza los elementos del HUD
    /// </summary>
    private void UpdateHUD()
    {
        if (playerController == null || economyManager == null)
            return;

        // Actualizar dinero
        float totalMoney = economyManager.GetTotalMoney();
        if (moneyText != null)
            moneyText.text = $"Dinero: ${totalMoney:F2}";

        // Actualizar nivel y experiencia
        if (levelText != null)
            levelText.text = $"Nivel: {playerController.GetPlayerLevel()}";

        if (experienceText != null)
            experienceText.text = $"XP: {playerController.GetPlayerExperience()}";

        // Actualizar misión
        Mission currentMission = missionManager.GetCurrentMission();
        if (missionText != null)
        {
            if (currentMission != null && currentMission.isActive)
            {
                missionText.text = $"Misión: {currentMission.title} ({currentMission.GetProgressPercent():F1}%)";
            }
            else
            {
                missionText.text = "Sin misión activa";
            }
        }

        // Actualizar barra de energía
        if (energyBar != null)
        {
            float energyPercent = playerController.GetCurrentEnergy() / playerController.GetMaxEnergy();
            energyBar.fillAmount = energyPercent;
        }

        // Actualizar hora (ejemplo simple)
        if (timeText != null)
        {
            float gameTime = GameManager.Instance.GetGameTime();
            int hours = (int)(gameTime / 60) % 24;
            int minutes = (int)gameTime % 60;
            timeText.text = $"{hours:D2}:{minutes:D2}";
        }
    }

    /// <summary>
    /// Maneja la entrada del usuario en UI
    /// </summary>
    private void HandleInputs()
    {
        // Pause (ESC)
        if (Input.GetKeyDown(KeyCode.Escape))
        {
            TogglePauseMenu();
        }

        // Inventario (I)
        if (Input.GetKeyDown(KeyCode.I))
        {
            ToggleInventory();
        }

        // Misiones (M)
        if (Input.GetKeyDown(KeyCode.M))
        {
            ToggleMissionPanel();
        }
    }

    /// <summary>
    /// Alterna el menú de pausa
    /// </summary>
    public void TogglePauseMenu()
    {
        isPauseMenuOpen = !isPauseMenuOpen;

        if (pauseMenuPanel != null)
            pauseMenuPanel.SetActive(isPauseMenuOpen);

        if (isPauseMenuOpen)
        {
            GameManager.Instance.PauseGame();
            Debug.Log("[UIManager] Menú de pausa abierto");
        }
        else
        {
            GameManager.Instance.ResumeGame();
            Debug.Log("[UIManager] Menú de pausa cerrado");
        }
    }

    /// <summary>
    /// Alterna el inventario
    /// </summary>
    public void ToggleInventory()
    {
        isInventoryOpen = !isInventoryOpen;

        if (inventoryPanel != null)
            inventoryPanel.SetActive(isInventoryOpen);

        Debug.Log(isInventoryOpen ? "[UIManager] Inventario abierto" : "[UIManager] Inventario cerrado");
    }

    /// <summary>
    /// Alterna el panel de misiones
    /// </summary>
    public void ToggleMissionPanel()
    {
        if (missionPanel != null)
        {
            bool isActive = !missionPanel.activeSelf;
            missionPanel.SetActive(isActive);
            Debug.Log(isActive ? "[UIManager] Panel de misiones abierto" : "[UIManager] Panel de misiones cerrado");
        }
    }

    /// <summary>
    /// Muestra un diálogo
    /// </summary>
    public void ShowDialog(string dialogText)
    {
        if (dialogPanel != null)
        {
            dialogPanel.SetActive(true);
            TextMeshProUGUI dialogTextComponent = dialogPanel.GetComponentInChildren<TextMeshProUGUI>();
            if (dialogTextComponent != null)
                dialogTextComponent.text = dialogText;
        }
    }

    /// <summary>
    /// Cierra el diálogo
    /// </summary>
    public void CloseDialog()
    {
        if (dialogPanel != null)
            dialogPanel.SetActive(false);
    }

    /// <summary>
    /// Muestra una notificación flotante
    /// </summary>
    public void ShowNotification(string message)
    {
        Debug.Log($"[UIManager] Notificación: {message}");
        // Aquí se implementaría la animación de notificación flotante
    }

    /// <summary>
    /// Obtiene si el inventario está abierto
    /// </summary>
    public bool IsInventoryOpen() => isInventoryOpen;

    /// <summary>
    /// Obtiene si el menú de pausa está abierto
    /// </summary>
    public bool IsPauseMenuOpen() => isPauseMenuOpen;
}
